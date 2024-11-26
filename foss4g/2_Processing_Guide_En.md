# mago3D Data Processing Guide

# Data Extraction

## 1. Overture Maps

- Preprocessing of GeoJSON data received in the Python virtual environment is required.
- Move all GeoJSON files received to the C:\mago3d\workspace folder from the C:\mago3d path where you set up the virtual environment.

### 1. khlongtoei_building.geojson

- This file will be converted to tileset.json using mago3d-tiler.
- The GeoJSON file includes buildings without height values, so we'll extract and process the building heights.
- Create a copy of khlongtoei_building.geojson named khlongtoei_building_origin.geojson.
- Extract building heights from khlongtoei_building_origin.geojson.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" /data/khlongtoei_hegiht.geojson /data/khlongtoei_building_origin.geojson -sql "SELECT height FROM khlongtoei_building_origin WHERE height IS NOT NULL"
    ```
- Convert building floor count to height values.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" /data/khlongtoei_num_floors.geojson /data/khlongtoei_building_origin.geojson -sql "SELECT num_floors * 3.3 AS height FROM khlongtoei_building_origin WHERE height IS NULL"
    ```
- Merge extracted building heights and floor-based heights.
    ```sql 
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" /data/khlongtoei_building.geojson /data/khlongtoei_hegiht.geojson
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GeoJSON" -append /data/khlongtoei_building.geojson /data/khlongtoei_num_floors.geojson
    ```
- Create an 'input' folder in C:\mago3d\workspace and place the merged khlongtoei_building.geojson file inside.

### 2. khlongtoei_transportation.geojson

- Convert to Geopackage file to upload as a layer to geoserver.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 ogr2ogr -f "GPKG" /data/rome_segments.gpkg /data/khlongtoei_transportation.geojson
    ```
- Create a 'data' folder in C:\mago3d\workspace\geoserver and place the converted gpkg file inside.

---

## 2. Copernicus Data Space Ecosystem

- Convert to GeoTIFF for uploading as a layer to geoserver.
- Unzip the downloaded SAFE.zip file.
- Move the T47PPR_20240430T033541_TCI_10m.jp2 file from GRANULE\L2A_T47PPR_A046247_20240430T034959\IMG_DATA\R10m path to C:\mago3d\workspace folder.
- Convert jp2 file to tif.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/data ghcr.io/osgeo/gdal:ubuntu-full-3.9.0 gdal_translate -of GTiff /data/T47PPR_20240430T033541_TCI_10m.jp2 /data/T47PPR_20240430T033541_TCI_10m.tif
    ```
- Place the converted tif file in C:\mago3d\workspace\geoserver\data path.

---

## 3. NASA DEM

- File to be converted to terrain information through mago3d-terrainer, also used when running mago3d-tiler.
- Open the downloaded ASTGTM_003-20241118_054943 folder and copy the ASTGTMV003_N13E100_dem.tif file.
- Paste the copied file into C:\mago3d\workspace\input path.
- Create a 'dem' folder in C:\mago3d\workspace and paste the copied file.

---

# Using MAGO3D

- Verify that data is correctly placed in input and dem folders in C:\mago3d\workspace path.
    - input > khlongtoei_building.geojson, ASTGTMV003_N13E100_dem.tif
    - dem > ASTGTMV003_N13E100_dem.tif

## MAGO3D-TILER

- Run mago3d-tiler with default building height set to 3.3m.
    ```sql
    $ docker run --rm -v C:\mago3d\workspace:/workspace gaia3d/mago-3d-tiler -input /workspace/input -output /workspace/output -it geojson -crs 4326 -te /workspace/dem/ASTGTMV003_N13E100_dem.tif -mh 3.3 -hc height
    ```

## MAGO3D-TERRAINER

- Run mago3d-terrainer with terrain level set to 14.
    ```sql
    $ docker run --rm -v C:\gaia3d\workspace:/workspace gaia3d/mago-3d-terrainer -input /workspace/dem -output /workspace/assets/terrain -cn -it bilinear -mn 0 -mx 14
    ```

---

# Using Geoserver

## 1. Accessing Geoserver

- Access geoserver using the port specified during installation.
    ```sql
    http://localhost:8080/geoserver
    ```
- Log in with the ID and password specified during installation.
    ```sql
     admin / geoserver
    ```
## 2. 

---

# Checking Results in Web Using Sample Code

- Open the C:\mago3d\workspace\index.html file in your preferred IDE.
- Modify codes with ✏️ icon to match your environment.
- Keep index.html open and activate the server to view results in Chrome.

## IDE

### 1. Intellij
![](images/en/intellijServer.png)

### 2. VsCode
![](images/en/vsCodeLiveExtension.png)
![](images/en/vsCodeServer.png)
