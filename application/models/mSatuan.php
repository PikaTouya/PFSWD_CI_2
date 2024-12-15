<?php 

class mSatuan extends CI_Model {
    function getData() {
        return $this->db->get("tbl_m_satuan")->result();
    }
}

?>