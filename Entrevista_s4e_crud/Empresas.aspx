<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Empresas.aspx.cs" Inherits="Entrevista_s4e_crud.Empresas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
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
    </style>
</head>
<body class="container">
    <div class="navbar">
        <a href="Home.aspx" class="active">Home</a>
        <a href="#">Empresas</a>
        <a href="#">Contact</a>
    </div>
    <form id="form1" runat="server">
        <br />
        <br />
          <h3>Pesquise por algum Filtro</h3>
        <div class="d-flex justify-content-between ">
            <div class="d-flex">
                <div>
                    <asp:TextBox Placeholder="Digite o nome da empresa" ID="txtFiltroNome" class="form-control" runat="server"></asp:TextBox>
                </div>
                <div style="margin-left: 20px">
                    <asp:TextBox Placeholder="Digite pelo Id da empresa" class="form-control" ID="txtFiltroId" runat="server"></asp:TextBox>
                </div>
            </div>
            <div>
                <asp:Button ID="Button2" runat="server" CssClass="btn button  btn-primary" Text="Filtrar" OnClick="btnFiltrar_Click" />
            </div>
        </div>

        <div class="row">
            <div class="col-md-4">
                <asp:Label ID="Label3" runat="server" Text="ID"></asp:Label>
                <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server" Enabled="False"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <asp:Label ID="Label1" runat="server" Text="Nome"></asp:Label>
                <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <asp:Label ID="Label2" runat="server" Text="CNPJ"></asp:Label>
            <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" onkeypress="return isNumberKey(event)"></asp:TextBox>
            </div>
        </div>

        <div>
            <br />
        <br />
            <asp:Button ID="Button1" CssClass="btn button  btn-primary" runat="server" Text="Cadastrar" OnClick="Button1_Click" />
            <br />
            <br />
            <asp:Label ID="Label4" runat="server"></asp:Label>
            <br />
            <br />
            <asp:GridView CssClass="table" OnRowDeleting="GridViewEmpresas_RowDeleting" OnRowCancelingEdit="GridViewEmpresas_RowCanceling" OnRowEditing="GridViewEmpresas_RowEditing" OnRowUpdating="GridViewEmpresas_RowUpdating" ID="GridViewEmpresas" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" >
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id" />
                    <asp:TemplateField HeaderText="Nome" SortExpression="Nome">
                        <ItemTemplate>
                            <asp:Label ID="lblNome" runat="server" Text='<%# Eval("Nome") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtNome" runat="server" Text='<%# Bind("Nome") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="CNPJ" SortExpression="CNPJ">
                        <ItemTemplate>
                            <asp:Label ID="lblCnpj" runat="server" Text='<%# Eval("CNPJ") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtCnpj" runat="server" Text='<%# Bind("CNPJ") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowEditButton="true" />
                    <asp:CommandField ShowDeleteButton="true" />
                </Columns>
            </asp:GridView>
           

        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>

    <script>
    function isNumberKey(evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }
    </script>

</body>
</html>
