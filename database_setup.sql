-- Library Management System Database Setup
-- Run this script in your MySQL database

-- Create books table
CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `isbn` varchar(20) NOT NULL,
  `description` text,
  `available` tinyint(1) DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `isbn` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create borrows table
CREATE TABLE IF NOT EXISTS `borrows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `borrow_date` datetime NOT NULL,
  `return_date` datetime NOT NULL,
  `actual_return_date` datetime NULL,
  `status` enum('borrowed','returned') DEFAULT 'borrowed',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `book_id` (`book_id`),
  KEY `user_email` (`user_email`),
  KEY `status` (`status`),
  CONSTRAINT `fk_borrow_book` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample books
INSERT INTO `books` (`title`, `author`, `isbn`, `description`, `available`) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '978-0743273565', 'A story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.', 1),
('To Kill a Mockingbird', 'Harper Lee', '978-0446310789', 'The story of young Scout Finch and her father Atticus in a racially divided Alabama town.', 1),
('1984', 'George Orwell', '978-0451524935', 'A dystopian novel about totalitarianism and surveillance society.', 1),
('Pride and Prejudice', 'Jane Austen', '978-0141439518', 'A romantic novel of manners that follows the emotional development of Elizabeth Bennet.', 1),
('The Hobbit', 'J.R.R. Tolkien', '978-0547928241', 'A fantasy novel about Bilbo Baggins, a hobbit who embarks on a quest.', 1),
('The Catcher in the Rye', 'J.D. Salinger', '978-0316769488', 'A novel about teenage alienation and loss of innocence in post-World War II America.', 1),
('Lord of the Flies', 'William Golding', '978-0399501487', 'A novel about a group of British boys stranded on an uninhabited island.', 1),
('Animal Farm', 'George Orwell', '978-0451526342', 'An allegorical novella about a group of farm animals who rebel against their human farmer.', 1),
('The Alchemist', 'Paulo Coelho', '978-0062315007', 'A novel about a young Andalusian shepherd who dreams of finding a worldly treasure.', 1),
('Brave New World', 'Aldous Huxley', '978-0060850524', 'A dystopian novel about a futuristic World State society.', 1);

-- Insert sample borrows (optional - for testing)
INSERT INTO `borrows` (`book_id`, `user_name`, `user_email`, `borrow_date`, `return_date`, `status`) VALUES
(1, 'John Doe', 'john@example.com', '2024-01-15 10:00:00', '2024-01-29 10:00:00', 'borrowed'),
(3, 'Jane Smith', 'jane@example.com', '2024-01-10 14:30:00', '2024-01-24 14:30:00', 'returned'),
(5, 'Mike Johnson', 'mike@example.com', '2024-01-20 09:15:00', '2024-02-03 09:15:00', 'borrowed');

-- Update book availability for borrowed books
UPDATE `books` SET `available` = 0 WHERE `id` IN (1, 5);
UPDATE `books` SET `available` = 1 WHERE `id` = 3;
