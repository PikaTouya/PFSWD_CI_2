<?php 

class Home extends CI_Controller {
    public function index() {
        $data['page'] = "home";
        $data['judul'] = "Beranda";
        $data['deskripsi'] = "Full Stack Web Development System";
        $this->template->views('home', $data);
    }
}

?>