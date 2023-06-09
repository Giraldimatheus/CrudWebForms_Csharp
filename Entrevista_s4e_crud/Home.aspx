<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Entrevista_s4e_crud.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style>
        .navbar {
            background-color: #f8f8f8;
            overflow: hidden;
        }

            .navbar a {
                float: left;
                display: block;
                color: #333;
                text-align: center;
                padding: 14px 14px;
                text-decoration: none;
            }

                .navbar a:hover {
                    background-color: #ddd;
                }

                .navbar a.active {
                    background-color: #4CAF50;
                    color: white;
                }

        .d-flex {
            display: flex;
        }
    </style>
</head>
<body class="container">
    <div class="navbar">
        <a href="#" class="active">Home</a>
        <a href="Empresas.aspx">Empresas</a>
        <a href="#">Contact</a>
    </div>

    <form id="form1" runat="server">
        <asp:ScriptManager runat="server"></asp:ScriptManager>

        <br />
        <br />
        <h3>Pesquise por algum Filtro</h3>
        <div class="d-flex justify-content-between ">
            <div class="d-flex">
                <div>
                    <asp:TextBox Placeholder="Digite o nome da pessoa" ID="txtFiltroNome" class="form-control" runat="server"></asp:TextBox>
                </div>
                <div style="margin-left: 20px">
                    <asp:TextBox Placeholder="Digite pelo Id da pessoa" class="form-control" ID="txtFiltroId" runat="server"></asp:TextBox>
                </div>
            </div>
            <div>
                <asp:Button ID="Button2" runat="server" CssClass="btn button  btn-primary" Text="Filtrar" OnClick="btnFiltrar_Click"/>
            </div>
        </div>





        <br />
        <br />
        <asp:Button ID="ChamaModal" CssClass="btn btn-primary" runat="server" Text="Cadastrar" OnClick="btnSubmit_Click" />
        <br />
        <br />

        <asp:Label ID="label4" runat="server" Text="" Visible="false"></asp:Label><br />
        <br />


        <asp:GridView CssClass="table" runat="server" DataKeyNames="Id" OnRowDeleting="GridViewFuncionarios_RowDeleting" AutoGenerateColumns="false" OnRowUpdating="GridViewFuncionarios_RowUpdating" OnRowEditing="GridViewFuncionarios_RowEditing" OnRowCancelingEdit="GridViewFuncionarios_RowCanceling" ID="GridViewFuncionarios">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="true" />
                <asp:TemplateField HeaderText="Nome">
                    <ItemTemplate>
                        <asp:Label ID="lblNome" runat="server" Text='<%# Eval("Nome") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtNome" runat="server" Text='<%# Eval("Nome") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="CPF">
                    <ItemTemplate>
                        <asp:Label ID="lblCpf" runat="server" Text='<%# Eval("Cpf") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtCpf" runat="server" Text='<%# Eval("Cpf") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Data de nascimento">
                    <ItemTemplate>
                        <asp:Label ID="lblDataNascimento" runat="server" Text='<%# Eval("DataNascimento", "{0:dd/MM/yyyy}") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtDataNascimento" runat="server" Text='<%# Eval("DataNascimento", "{0:dd/MM/yyyy}") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Empresas">
                    <ItemTemplate>
                        <asp:Label ID="lblEmpresas" runat="server" Text='<%# GetEmpresasPessoa(Eval("Id")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowEditButton="true" />
                <asp:CommandField ShowDeleteButton="true" />
            </Columns>
        </asp:GridView>


        <div class="modal fade modal-lg" id="myModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <asp:UpdatePanel ID="upModal" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title">
                                    <asp:Label ID="lblModalTitle" runat="server" Text=""></asp:Label>
                                </h4>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <asp:Label runat="server" Text="ID"></asp:Label>
                                        <asp:TextBox CssClass="form-control" runat="server" Enabled="False"></asp:TextBox>
                                    </div>

                                    <div class="col-md-4">
                                        <asp:Label ID="Label1" runat="server" Text="Nome"></asp:Label>
                                        <asp:TextBox ID="TextBox1" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>

                                    <div class="col-md-4">
                                        <asp:Label ID="Label2" runat="server" Text="CPF"></asp:Label>
                                        <asp:TextBox ID="TextBox2" CssClass="form-control" runat="server" onkeypress="return isNumberKey(event)"></asp:TextBox>
                                    </div>

                                    <div class="col-md-4">
                                        <asp:Label ID="Label3" runat="server" Text="Data de Nascimento"></asp:Label>
                                        <asp:TextBox ID="TextBox3" CssClass="form-control" runat="server" onkeyup="formatDate(this)" MaxLength="10"></asp:TextBox>
                                    </div>

                                    <div class="col-md-4">
                                        <asp:Label ID="Label5" runat="server" Text="Empresa"></asp:Label>
                                        <asp:ListBox ID="Select1" runat="server" CssClass="form-select" SelectionMode="multiple"></asp:ListBox>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="Button3" CssClass="btn btn-primary" runat="server" Text="Cadastrar" OnClick="Button1_Click" />
                                <button class="btn btn-danger" data-dismiss="modal" aria-hidden="true">Close</button>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
    <script>
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        function fecharModal() {
            
            location.href = location.href;
            $('#myModal').modal('hide');
                
        }
        function formatDate(input) {
            var value = input.value;
            value = value.replace(/\D/g, '');

            // Verifica se o valor possui 8 caracteres (ddmmyyyy)
            if (value.length === 8) {
                // Adiciona as barras nos locais apropriados (dd/mm/yyyy)
                value = value.replace(/(\d{2})(\d{2})(\d{4})/, '$1/$2/$3');
            }



            // Atualiza o valor do campo
            input.value = value;
        }

    </script>


</body>
</html>
