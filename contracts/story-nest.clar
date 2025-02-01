;; Story NFT definitions
(define-non-fungible-token story uint)

;; Data structures
(define-map stories
  uint 
  {
    creator: principal,
    title: (string-utf8 100),
    content: (string-utf8 1000),
    metadata: (string-utf8 500),
    created-at: uint,
    likes: uint
  }
)

(define-map comments
  { story-id: uint, comment-id: uint }
  {
    author: principal,
    content: (string-utf8 280),
    created-at: uint
  }
)

(define-map user-follows 
  { follower: principal, following: principal }
  { active: bool }
)

;; Variables
(define-data-var story-counter uint u0)
(define-data-var comment-counter uint u0)

;; Public functions
(define-public (create-story (title (string-utf8 100)) (content (string-utf8 1000)) (metadata (string-utf8 500)))
  (let ((story-id (+ (var-get story-counter) u1)))
    (try! (nft-mint? story story-id tx-sender))
    (map-set stories story-id {
      creator: tx-sender,
      title: title,
      content: content, 
      metadata: metadata,
      created-at: block-height,
      likes: u0
    })
    (var-set story-counter story-id)
    (ok story-id)))

(define-public (like-story (story-id uint))
  (let ((story (unwrap! (map-get? stories story-id) (err u401))))
    (map-set stories story-id 
      (merge story { likes: (+ (get likes story) u1) }))
    (ok true)))

(define-public (add-comment (story-id uint) (content (string-utf8 280)))
  (let ((comment-id (+ (var-get comment-counter) u1)))
    (map-set comments 
      { story-id: story-id, comment-id: comment-id }
      {
        author: tx-sender,
        content: content,
        created-at: block-height
      })
    (var-set comment-counter comment-id)
    (ok comment-id)))

(define-public (follow-user (user principal))
  (map-set user-follows
    { follower: tx-sender, following: user }
    { active: true })
  (ok true))
