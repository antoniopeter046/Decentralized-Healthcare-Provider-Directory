;; Provider Verification Contract
;; Stores and verifies healthcare provider information

(define-data-var admin principal tx-sender)

;; Provider status enum
(define-constant STATUS_PENDING u0)
(define-constant STATUS_VERIFIED u1)
(define-constant STATUS_REVOKED u2)

;; Provider data structure
(define-map providers
  { provider-id: (string-ascii 32) }
  {
    name: (string-ascii 100),
    license-number: (string-ascii 50),
    license-state: (string-ascii 2),
    npi: (string-ascii 10),
    status: uint,
    verifier: (optional principal),
    verification-date: (optional uint)
  }
)

;; Provider ID to principal mapping
(define-map provider-principals
  { principal: principal }
  { provider-id: (string-ascii 32) }
)

;; Get admin
(define-read-only (get-admin)
  (var-get admin)
)

;; Update admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)

;; Register a new provider
(define-public (register-provider
    (provider-id (string-ascii 32))
    (name (string-ascii 100))
    (license-number (string-ascii 50))
    (license-state (string-ascii 2))
    (npi (string-ascii 10)))
  (begin
    (asserts! (is-none (map-get? providers { provider-id: provider-id })) (err u400))
    (map-set providers
      { provider-id: provider-id }
      {
        name: name,
        license-number: license-number,
        license-state: license-state,
        npi: npi,
        status: STATUS_PENDING,
        verifier: none,
        verification-date: none
      }
    )
    (map-set provider-principals
      { principal: tx-sender }
      { provider-id: provider-id }
    )
    (ok true)
  )
)

;; Verify a provider
(define-public (verify-provider (provider-id (string-ascii 32)))
  (let ((provider (unwrap! (map-get? providers { provider-id: provider-id }) (err u404))))
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-eq (get status provider) STATUS_PENDING) (err u400))
    (map-set providers
      { provider-id: provider-id }
      (merge provider {
        status: STATUS_VERIFIED,
        verifier: (some tx-sender),
        verification-date: (some block-height)
      })
    )
    (ok true)
  )
)

;; Revoke a provider's verification
(define-public (revoke-provider (provider-id (string-ascii 32)))
  (let ((provider (unwrap! (map-get? providers { provider-id: provider-id }) (err u404))))
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-eq (get status provider) STATUS_VERIFIED) (err u400))
    (map-set providers
      { provider-id: provider-id }
      (merge provider {
        status: STATUS_REVOKED
      })
    )
    (ok true)
  )
)

;; Get provider information
(define-read-only (get-provider (provider-id (string-ascii 32)))
  (map-get? providers { provider-id: provider-id })
)

;; Get provider ID by principal
(define-read-only (get-provider-id-by-principal (provider-principal principal))
  (map-get? provider-principals { principal: provider-principal })
)

;; Check if provider is verified
(define-read-only (is-provider-verified (provider-id (string-ascii 32)))
  (match (map-get? providers { provider-id: provider-id })
    provider (is-eq (get status provider) STATUS_VERIFIED)
    false
  )
)
