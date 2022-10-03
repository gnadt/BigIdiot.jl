"""
    image2kmz(img_xx, img_yy, img_file::String;
              img_deg  = 0.2,
              plot_alt = 1000,
              opacity  = 1.00)

Create kmz file of image overlay for use with Google Earth.

**Arguments:**
- `img_xx`:   image center x-direction (longitude) coordinate [deg]
- `img_yy`:   image center y-direction (latitude)  coordinate [deg]
- `img_file`: image name
- `img_deg`:  (optional) image size on map [deg]
- `plot_alt`: (optional) image altitude [m]
- `opacity`:  (optional) image opacity {0:1}

**Returns:**
- `nothing`: kmz file `img_file`.kmz is created
"""
function image2kmz(img_xx, img_yy, img_file::String;
                   img_deg  = 0.2,
                   plot_alt = 1000,
                   opacity  = 1.00)

    img_name  = img_file[1:findlast('.',img_file)-1]
    img_kml   = string(img_name,".kml")
    img_kmz   = string(img_name,".kmz")
    img_trans = string(string(round(Int,opacity*255),base=16),"ffffff") # ABGR

    p1      = load(img_file)
    (h1,w1) = size(p1)
    scale   = img_deg/max(h1,w1)

    img_west  = img_xx - w1/2*scale
    img_east  = img_xx + w1/2*scale
    img_south = img_yy - h1/2*scale*dn2dlat(1,deg2rad(img_yy))/de2dlon(1,deg2rad(img_yy))
    img_north = img_yy + h1/2*scale*dn2dlat(1,deg2rad(img_yy))/de2dlon(1,deg2rad(img_yy))

    open(img_kml,"w") do file
        println(file,
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n",
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\"> \n",
        "  <Document> ")

        println(file,
        "    <Folder> \n",
        "      <GroundOverlay> \n",
        "        <Icon> \n",
        "          <href>",img_file,"</href> \n",
        "        </Icon> \n",
        "        <color>",img_trans,"</color> ")
        if plot_alt > 0 # put map at altitude specified, otherwise ground
        println(file,
        "        <altitude>",plot_alt,"</altitude> \n",
        "          <altitudeMode>absolute</altitudeMode> ")
        end
        println(file,
        "        <LatLonBox> \n",
        "          <north>",img_north,"</north> \n",
        "          <south>",img_south,"</south> \n",
        "          <east>",img_east,"</east> \n",
        "          <west>",img_west,"</west> \n",
        "          <rotation>0</rotation> \n",
        "        </LatLonBox> \n",
        "      </GroundOverlay> \n",
        "    </Folder> ")

        println(file,
        "  </Document> \n",
        "</kml> ")
    end

    w = ZipFile.Writer(img_kmz)

    for file in [img_kml,img_file]
        f = ZipFile.addfile(w,file,method=ZipFile.Deflate)
        write(f,read(file))
    end

    close(w)
    rm(img_kml)

end # function image2kmz
