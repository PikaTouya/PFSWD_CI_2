
<?php 
defined('BASEPATH') OR exit('No direct script access allowed');
class Kategori extends CI_Controller{ 
    function __construct(){  
        parent::__construct(); 
        $this->load->model('mKategori'); 
    }

    function index(){ 
        $data['page'] = "Kategori"; 
        $data['judul'] = "Data Kategori"; 
        $data['deskripsi'] = "Manage Data Kategori"; 
        $data['data'] = $this->mKategori->getData(); 
        $this->template->views('view_kategori', $data);
    }

    function tambahData(){ 
        $this->form_validation->set_rules('nama_kategori', 'Nama Kategori', 'required'); 
        if ($this->form_validation->run() == FALSE) { 
            $response = array('responce' => 'error', 'message' => validation_errors()); 
        }else{ 
            $nama_kategori = $this->input->post('nama_kategori'); 
            $validData = $this->mKategori->cekDuplicate($nama_kategori); 
            if ($validData>=1){ 
                $response = array('responce' => 'error', 'message' => 'Nama Kategori Barang Sudah Terdaftar..'); 
            }else{ 
                $data = ['nama_kategori' => $nama_kategori]; 
                if ($this->mKategori->insertData($data)) {
                    $response = array('responce' => 'success', 'message' => 'Record added Successfully'); 
                } else { 
                    $response = array('responce' => 'error', 'message' => 'Terjadi Kesalahan, Data GAGAL di Simpan'); 
                }
            } 
        } 
        echo json_encode($response); 
    }

    function perbaruiData(){ 
        $this->form_validation->set_rules('nama_kategori', 'Nama Kategori', 'required'); 
        $this->form_validation->set_rules('id_kategori', 'ID Kategori', 'required'); 
        if ($this->form_validation->run() == FALSE) { 
            $response = array('responce' => 'error', 'message' => validation_errors()); 
        }else{ 
            $nama_kategori = $this->input->post('nama_kategori'); 
            $id_kategori = $this->input->post('id_kategori'); 
            $validData = $this->mKategori->cekDuplicate($nama_kategori); 
            if ($validData>=1){ 
                $response = array('responce' => 'error', 'message' => 'Nama Kategori Barang Sudah Terdaftar..'); 
            }else{ 
                $data = ['nama_kategori' => $nama_kategori]; 
                if ($post = $this->mKategori->updateData($id_kategori, $data)) { 
                    $response = array('responce' => 'success', 'message' => 'Record update Successfully'); 
                } else { 
                    $response = array('responce' => 'error', 'message' => 'Terjadi Kesalahan, Data GAGAL di Simpan'); 
                } 
            } 
        } 
        echo json_encode($response); 
    }

    function tampilkanDataByID(){ 
        $id_kategori = $this->input->post('id_kategori'); 
        $data = $this->mKategori->getDataById($id_kategori); 
        echo json_encode($data);
    }

    function tampilkanData(){ 
        $data = $this->mKategori->getData(); 
        echo json_encode($data);
    }
    
    function hapusData(){ 
        if ($this->input->is_ajax_request()) { 
            $id = $this->input->post('id_kategori'); 
            if ($this->mKategori->deleteData($id)) { 
                $data = array('responce' => 'success'); 
            } else { 
                $data = array('responce' => 'error'); 
            } 
            echo json_encode($data); 
        } else { 
            echo "No direct script access allowed"; 
        } 
    }
}