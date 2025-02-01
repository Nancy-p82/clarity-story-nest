;; Token for platform rewards
(define-fungible-token story-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))

;; Token info
(define-data-var token-uri (string-utf8 256) "")

;; Mint new tokens - only contract owner
(define-public (mint (amount uint) (recipient principal))
  (if (is-eq tx-sender contract-owner)
    (ft-mint? story-token amount recipient)
    err-owner-only))

;; Transfer tokens
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (ft-transfer? story-token amount sender recipient))

;; Get token balance
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance story-token account)))
