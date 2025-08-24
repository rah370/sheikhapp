<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Borrow_model extends CI_Model {
    
    public function __construct() {
        parent::__construct();
    }
    
    public function borrow_book($book_id, $user_name, $user_email) {
        $data = array(
            'book_id' => $book_id,
            'user_name' => $user_name,
            'user_email' => $user_email,
            'borrow_date' => date('Y-m-d H:i:s'),
            'return_date' => date('Y-m-d H:i:s', strtotime('+14 days')),
            'status' => 'borrowed'
        );
        
        $this->db->insert('borrows', $data);
        
        if ($this->db->affected_rows() > 0) {
            // Update book availability
            $this->load->model('Book_model');
            $this->Book_model->update_book_availability($book_id, 0);
            return true;
        }
        return false;
    }
    
    public function return_book($borrow_id) {
        $this->db->select('book_id');
        $this->db->from('borrows');
        $this->db->where('id', $borrow_id);
        $query = $this->db->get();
        $borrow = $query->row();
        
        if ($borrow) {
            // Update borrow status
            $data = array(
                'status' => 'returned',
                'actual_return_date' => date('Y-m-d H:i:s')
            );
            $this->db->where('id', $borrow_id);
            $this->db->update('borrows', $data);
            
            // Update book availability
            $this->load->model('Book_model');
            $this->Book_model->update_book_availability($borrow->book_id, 1);
            return true;
        }
        return false;
    }
    
    public function get_user_borrows($user_email) {
        $this->db->select('borrows.*, books.title, books.author');
        $this->db->from('borrows');
        $this->db->join('books', 'books.id = borrows.book_id');
        $this->db->where('borrows.user_email', $user_email);
        $this->db->order_by('borrows.borrow_date', 'DESC');
        $query = $this->db->get();
        return $query->result();
    }
    
    public function get_all_borrows() {
        $this->db->select('borrows.*, books.title, books.author');
        $this->db->from('borrows');
        $this->db->join('books', 'books.id = borrows.book_id');
        $this->db->order_by('borrows.borrow_date', 'DESC');
        $query = $this->db->get();
        return $query->result();
    }
}
