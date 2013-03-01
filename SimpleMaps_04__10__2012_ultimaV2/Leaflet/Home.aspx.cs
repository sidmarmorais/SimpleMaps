using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace Leaflet
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            txtIdMapa.Value = (Session["idMapa"] ?? "").ToString();
            txtNomeMapa.Value = (Session["nomeMapa"] ?? "").ToString();
        }
        public void DefineInfoMapa(int id, string nome)
        {
            Session["idMapa"] = id;
            Session["nomeMapa"] = nome;
            txtIdMapa.Value = id.ToString();
            txtNomeMapa.Value = nome;
        }
    }
}
