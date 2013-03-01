<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Upload.aspx.cs" Inherits="Leaflet.Upload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Upload de Imagem</title>
    <link href="main.css" rel="stylesheet" type="text/css" />
</head>
<body style="background-color: #fff; color: #000; font-size: smaller; font-family: Helvetica, Arial, sans-serif">
    <form id="form1" runat="server">
    <div>
    <asp:Literal ID="lblScript" runat="server"></asp:Literal>
    <asp:Label ID="lblImagem" runat="server" Text="Selecione a imagem para fazer o upload:"></asp:Label><br />
    <asp:FileUpload ID="txtImagem" runat="server"  /><br />
    <br />
    <asp:Label ID="lblComments" runat="server" Text="Opcionalmente, você pode adicionar um comentário para a imagem:"></asp:Label><br />
    <asp:TextBox ID="txtComments" runat="server" Rows="4" Columns="25" MaxLength="256" Wrap="true" TextMode="MultiLine"></asp:TextBox><br />
    <br />
    <asp:Label ID="lblErro" runat="server" Text=""></asp:Label>
    <br />
    <asp:Button ID="btnUpload" runat="server" Text="Upload" onclick="btnUpload_Click"/>
    <input type="button" value="Cancelar" onclick="window.close();" />
    </div>
    </form>
</body>
</html>
