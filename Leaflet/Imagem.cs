﻿using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace Leaflet
{
    public class Imagem
    {
        public int id_imagem;
        public string latitude;
        public string longitude;
        public string texto;
        public int id_tipo_mapa;
        public string imagem;
    }
}
