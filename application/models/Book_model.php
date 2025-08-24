<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Book_model extends CI_Model {
    
    public function __construct() {
        parent::__construct();
    }
    
    public function get_all_books() {
        $this->db->select('*');
        $this->db->from('books');
        $this->db->where('available', 1);
        $query = $this->db->get();
        return $query->result();
    }
    
    public function get_book_by_id($id) {
        $this->db->select('*');
        $this->db->from('books');
        $this->db->where('id', $id);
        $query = $this->db->get();
        return $query->row();
    }
    
    public function search_books($keyword) {
        $this->db->select('*');
        $this->db->from('books');
        $this->db->like('title', $keyword);
        $this->db->or_like('author', $keyword);
        $this->db->or_like('isbn', $keyword);
        $this->db->where('available', 1);
        $query = $this->db->get();
        return $query->result();
    }
    
    public function update_book_availability($book_id, $available) {
        $data = array('available' => $available);
        $this->db->where('id', $book_id);
        return $this->db->update('books', $data);
    }
}
