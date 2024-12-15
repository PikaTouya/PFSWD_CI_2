<div class="row">
    <div class="col-md-12">
        <div class="box box-danger">
            <div class="box-header with-border color-header">
                <h3 class="box-title"><i class="fa fa-th"></i> Data Kategori Barang</h3>
                <div class="box-tools pull-right">
                    <a class="btn btn-default btn-sm" href="<?php echo base_url('Kategori'); ?>">
                        <span class="fa fa-refresh"></span> Refresh
                    </a>
                    <button type="button" class="btn btn-sm btn-success btnTambah" id="btnTambah"> 
                        <span class="fa fa-plus"></span class> Tambah</button>
                </div>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-12">
                        <table class="table table-bordered table-condensed" id="mydata">
                            <thead>
                            <tr>
                                <th style='width:30px; text-align:center'>#No</th>
                                <th>Kategori Barang</th>
                                <th style='width:120px; text-align:center'>Nama Kategori</th>
                            </tr>
                            </thead>
                            <tbody id="tbl_data">
                                
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Kategori--> 
<div class="modal fade" id="formModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true"> 
    <div class="modal-dialog modal-dialog-centered" role="document"> 
        <div class="modal-content"> 
            <div class="modal-header"> 
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"> 
                    <span aria-hidden="true">&times;</span> 
                </button> 
                <h4 class="modal-title" id="formModal">Tambah Kategori Barang</h4> 
            </div> 
            <div class="modal-body"> 
                <form action="" method="post" id="form_add"> 
                    <input type="hidden" id="id_kategori" name="id_kategori"> 
                    <div class="form-group"> 
                        <label>Nama Kategori</label> 
                        <input type="text" class="form-control" name="nama_kategori" id="nama_kategori" placeholder="Nama Kategori"> 
                    </div> 
                    <div class="modal-footer"> 
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Tutup</button> 
                        <button type="button" class="btn btn-primary" id="btnSimpan" data-loading-text="<i class='fa fa-circle-o-notch fa-spin'></i> Processing ">Simpan Data</button>
                    </div> 
                </form> 
            </div> 
        </div> 
    </div> 
</div> 
<!-- End Modal Add Kategori-->

<script type="text/javascript"> 
    $(document).ready(function(){ 
        var btnEdit = false; 
        tampil_data(); 
        //Menampilkan Data di tabel 
        function tampil_data(){ 
            $.ajax({ 
                url: '<?php echo base_url(); ?>kategori/tampilkanData', 
                type: 'POST', 
                dataType: 'json', 
                success: function (response) { 
                    var i; 
                    var no = 0; 
                    var html = ""; 
                    for(i=0;i < response.length; i++){ 
                        no++; 
                        html = html + '<tr>' 
                        + '<td>' + no + '</td>' 
                        + '<td>' + response[i].nama_kategori + '</td>' 
                        + '<td><center>' + '<span><button edit-id="'+response[i].id_kategori+ 
                            '" class="btn btn-success btn-xs btn_edit"><i class="fa fa-edit"></i> Edit</button><button style="margin-left: 5px;" data-id="'
                            +response[i].id_kategori+'" class="btn btn-danger btn-xs btn_hapus"><i class="fa fa-trash"></i> Hapus</button></span>' + '</td>' + '</tr>'; 
                        } 
                        $("#tbl_data").html(html); 
                        $('#mydata').DataTable(); 
                    }, 
                    error: function (xhr, ajaxOptions, thrownError) { 
                        alert(xhr.status); 
                        alert(thrownError); 
                    } 
                }); 
            }

            //Memanggil Modal kategori 
            $(document).on("click", "#btnTambah", function(e){ 
                e.preventDefault(); 
                bEdit=false; 
                $('#form_add')[0].reset(); // reset form on modals 
                $('.form-group').removeClass('has-error'); // clear error class 
                $('.help-block').empty(); // clear error string 
                $('#formModal').modal('show'); // Tampilkan bootstrap modal 
                $('.modal-title').text('Tambah Kategori Barang'); // Set Judul modal 
            });

            //Edit Kategori 
            $("#tbl_data").on('click','.btn_edit', function(){ 
                var id_kategori = $(this).attr('edit-id'); 
                bEdit=true; 
                $.ajax({ 
                    url: '<?php echo base_url(); ?>kategori/tampilkanDataByID', 
                    type: 'POST', 
                    data: {id_kategori:id_kategori}, 
                    dataType: "json", 
                    success: function (response) { 
                        $('#form_add')[0].reset(); // reset form on modals 
                        $('.form-group').removeClass('has-error'); // clear error class 
                        $('.help-block').empty(); // clear error string 
                        $('.modal-title').text('Edit Kategori Barang'); // Set Title to Bootstrap modal title 
                        $('input[name="nama_kategori"]').val(response.nama_kategori); 
                        $('input[name="id_kategori"]').val(response.id_kategori); 
                        $("#formModal").modal('show'); 
                    } 
                }) 
            });

            //Kirim Data Proses Save/Update ke Controller 
            $(document).on("click", "#btnSimpan", function(e){ 
                e.preventDefault(); 
                var $this = $(this); 
                var id_kategori = $("#id_kategori").val(); 
                var nama_kategori = $("#nama_kategori").val(); 
                //Periksa apakah tombol edit ? 
                if (bEdit){ 
                    var sURL='<?php echo base_url(); ?>kategori/perbaruiData'; 
                }else{ 
                    var sURL='<?php echo base_url(); ?>kategori/tambahData'; 
                }
                $.ajax({ 
                    url: sURL, 
                    type: "post", 
                    dataType: "json", 
                    data: {id_kategori:id_kategori, nama_kategori:nama_kategori}, 
                        beforeSend: function () { 
                            $this.button('loading'); 
                        }, 
                        complete: function () { 
                            $this.button('reset'); 
                        }, 
                        success: function(data) { 
                            if (data.responce == "success") { 
                                $("#form_add")[0].reset(); 
                                $(".form-group").removeClass('has-error'); // clear error class 
                                $(".help-block").empty(); // clear error string 
                                $("#formModal").modal('hide'); 
                                Swal.fire({ 
                                    text: 'Data berhasil di Simpan', 
                                    icon: 'success', 
                                    title: 'Saving Succes', 
                                    showConfirmButton: false, 
                                    timer: 1500 
                                }); 
                                $('#mydata').dataTable({"bDestroy": true}).fnDestroy(); 
                                tampil_data(); 
                            }else{ 
                                Swal.fire('Error!', 'Ops! <br>' + data.message, 'error'); 
                            } 
                        }
                    }); 
                });

                //Hapus Data 
                $("#tbl_data").on('click','.btn_hapus', function(e){ 
                    e.preventDefault(); 
                    var id_kategori = $(this).attr('data-id'); 
                    Swal.fire({ 
                        title: 'Hapus Data?', 
                        text: 'Anda Yakin menghapus Data Kategori ini?', 
                        icon: 'warning', 
                        showCancelButton: true, 
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6', 
                        cancelButtonText: 'Tidak', 
                        confirmButtonText: 'Ya', 
                        showLoaderOnConfirm: true, 
                        preConfirm: () => { 
                            return new Promise(function(resolve, reject) { 
                                $.ajax({ 
                                    url: '<?php echo base_url(); ?>kategori/hapusData', 
                                    type: 'POST', 
                                    dataType: "json", 
                                    data: {id_kategori: id_kategori} 
                                }) 
                                .done(function(data) { 
                                    resolve(data) 
                                }) 
                                .fail(function() { 
                                    reject() 
                                }); 
                            }) 
                        }, 
                        allowOutsideClick: () => !swal.isLoading() 
                    }).then((result) => { 
                        if (result.value) { 
                            $('#mydata').dataTable({"bDestroy": true}).fnDestroy(); 
                            tampil_data(); 
                            Swal.fire({ 
                                icon: 'success', 
                                title: 'Data Telah Berhasil di Hapus', 
                                howConfirmButton: false, 
                                timer: 1500 
                            }) 
                        } 
                    }) 
                });
            })
</script>