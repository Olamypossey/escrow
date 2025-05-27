(define-constant buyer 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-constant seller 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

(define-data-var approved-by-buyer bool false)
(define-data-var approved-by-seller bool false)
(define-data-var deposited uint u0)

;; Buyer deposits funds into escrow
(define-public (deposit (amount uint))
  (begin
    (asserts! (is-eq tx-sender buyer) (err u100)) ;; Only buyer can deposit
    (asserts! (is-eq (var-get deposited) u0) (err u101)) ;; Prevent multiple deposits
    (asserts! (> amount u0) (err u105)) ;; Amount must be greater than 0
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set deposited amount)
    (ok true)
  )
)

;; Buyer or seller approves the release
(define-public (approve)
  (begin
    (if (is-eq tx-sender buyer)
      (ok (var-set approved-by-buyer true))
      (if (is-eq tx-sender seller)
        (ok (var-set approved-by-seller true))
        (err u103) ;; Invalid sender
      )
    )
  )
)

;; Release funds to seller if both approved
(define-public (release)
  (begin
    (asserts! (and (var-get approved-by-buyer) (var-get approved-by-seller)) (err u104))
    (let ((amount (var-get deposited)))
      (begin
        (var-set deposited u0)
        (try! (stx-transfer? amount (as-contract tx-sender) seller))
        (ok true)
      )
    )
  )
)

;; View deposit status
(define-read-only (get-deposit)
  (ok (var-get deposited))
)
