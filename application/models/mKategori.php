
<?php 
class mKategori extends CI_Model { 
    function getData(){ 
        return $this->db->get('tbl_m_kategori')->result(); 
    } 

    //Menambahkan data (Cread) 
    function insertData($data) { 
        return $this->db->insert('tbl_m_kategori', $data); 
    } 

    //Untuk Menampilkan Data berdasarkan ID (Read) 
    function getDataById($id) { 
        $this->db->where('id_kategori', $id); 
        return $this->db->get('tbl_m_kategori')->row();
    }

    //Update Data berdasarkan ID (Update) 
    function updateData($id, $data) { 
        $this->db->where('id_kategori', $id); 
        return $this->db->update('tbl_m_kategori', $data); 
    } 

    //Menghapus data berdasarkan ID (Delete) 
    function deleteData($id) { 
        $this->db->where('id_kategori', $id); 
        return $this->db->delete('tbl_m_kategori'); 
    }

    //Validasi Data Duplikat 
    function cekDuplicate ($kategori) { 
        $this->db->where('nama_kategori', $kategori); 
        $query = $this->db->get('tbl_m_kategori'); 
        return $query->num_rows();
    }
}