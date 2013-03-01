using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace Leaflet
{
    public partial class Upload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!txtImagem.HasFile)
            {
                lblErro.Text = "Por favor, selecione um arquivo antes de prosseguir";
            }
            else
            {
                if (txtImagem.PostedFile.ContentType.Equals("image/jpeg") ||
                    txtImagem.PostedFile.ContentType.Equals("image/pjpeg") ||
                    txtImagem.PostedFile.ContentType.Equals("image/gif") ||
                    txtImagem.PostedFile.ContentType.Equals("image/png") ||
                    txtImagem.PostedFile.ContentType.Equals("image/svg+xml"))
                {
                    if (txtImagem.PostedFile.ContentLength <= (2 * 1024 * 1024))
                    {
                        object id = Session["id"];
                        object idMapa = Session["idMapa"];
                        if (id != null && id is int && idMapa != null && idMapa is int)
                        {
                            //salva a foto
                            try
                            {
                                //valida o caminho de onde salvar a foto
                                string path = Server.MapPath("users");
                                if (!System.IO.Directory.Exists(path))
                                    System.IO.Directory.CreateDirectory(path);
                                path = System.IO.Path.Combine(path, id.ToString());
                                if (!System.IO.Directory.Exists(path))
                                    System.IO.Directory.CreateDirectory(path);
                                path = System.IO.Path.Combine(path, idMapa.ToString());
                                if (!System.IO.Directory.Exists(path))
                                    System.IO.Directory.CreateDirectory(path);

                                string arquivo = DateTime.Now.ToBinary().ToString("X16") +
                                    txtImagem.PostedFile.ContentType.Substring(6);
                                txtImagem.PostedFile.SaveAs(System.IO.Path.Combine(path, arquivo));
                                System.IO.File.WriteAllBytes(
                                    System.IO.Path.Combine(path, arquivo + ".txt"),
                                    System.Text.Encoding.UTF8.GetBytes(txtComments.Text));

                                lblScript.Visible = true;
                                lblImagem.Visible = false;
                                txtImagem.Visible = false;
                                lblComments.Visible = false;
                                txtComments.Visible = false;
                                lblErro.Visible = false;
                                btnUpload.Visible = false;
                            }
                            catch (Exception ex)
                            {
                                lblErro.Text = "Erro ao tentar salvar a imagem: " + ex.Message;
                            }
                        }
                        else
                        {
                            lblErro.Text = "Não é possível prosseguir sem efetuar login";
                        }
                    }
                    else
                    {
                        lblErro.Text = "Por favor, selecione um arquivo de foto com tamanho de até 2MB";
                    }
                }
                else
                {
                    lblErro.Text = "Por favor, selecione um arquivo com uma imagem válida (jpg, gif, png, svg)";
                }
            }
        }
    }
}
