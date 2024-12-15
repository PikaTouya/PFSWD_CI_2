<?php 
defined('BASEPATH') OR exit('No direct script access allowed');
class Satuan extends CI_Controller {
    function __construct(){
        parent::__construct();
        $this->load->model("mSatuan"); //panggil msatuan yang ada di folder Models
    }

    function index(){
        $data['page'] = "Satuan"; 
        $data['judul'] = "Data Satuan"; 
        $data['deskripsi'] = "Manage Data Satuan";
        $data["data"] = $this->mSatuan->getData(); // panggil function getData
        $this->template->views("view_satuan",$data); // tampilkan hasil pada view
    }
    function tampilkanData(){ 
        $data = $this->mSatuan->getData(); 
        echo json_encode($data);
    }
    function tampilkanDataByID(){ 
        $id_satuan = $this->input->post('id_satuan'); 
        $data = $this->mSatuan->getDataById($id_satuan); 
        echo json_encode($data);
    }
}


?>