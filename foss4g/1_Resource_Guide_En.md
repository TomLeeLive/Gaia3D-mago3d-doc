# mago3D Data Collection Guide

# :bookmark_tabs: Data Construction Approach

## ⚙️ Basic Setup

### 1. Create Files in Desired Path

- For example, create mago3d and workspace folders in the C:/ path.
    ```sql
    C:\Users\user> mkdir ../../mago3d/workspace
    ```

### 2. Download Necessary Items in Docker

- Open cmd prompt.
- Install mago3d-tiler.
    ```sql
    $ docker pull gaia3d/mago-3d-tiler
    ```
- Install mago3d-terrainer.
    ```sql
    $ docker pull gaia3d/mago-3d-terrainer
    ```
- Install geoserver in the directory you created.
    ```sql
    $ docker run -v C:\mago3d\workspace\geoserver:/apt/geoserver/data_dir -e GEOSEVER_ADMIN_USER=admin -e GEOSERVER_ADMIN_PASSWORD=geoserver -p 8080:8080 kartoza/geoserver
    ```

### 3. Download Cesium Sample Code

- Download the index.html file from the scripts folder and place it in the C:\mago3d\workspace directory.

## :globe_with_meridians: Overture Maps Data Download

### 1. Verify Python Installation

- [Install Python](https://www.python.org/downloads/)
- Open cmd prompt and verify Python installation. Enter the following command.
    ```sql
    $ python --version
    ```

### 2. Create Virtual Environment

- Navigate to the directory where you want to create the virtual environment in the cmd prompt. To move to the previously created directory, enter:
    ```sql
    $ cd C:\mago3d
    ```

- Enter the following command to create a virtual environment.
    ```sql
    $ python -m venv myvenv
    ```

- Here, 'myvenv' is the name of the virtual environment. You can change it to your preferred name.

### 3. Activate Virtual Environment

- To activate the virtual environment, enter the following command in the cmd prompt.
    ```sql
    $ myvenv\Scripts\activate
    ```

- After executing this command, the prompt will change to '(myvenv)', indicating the virtual environment is activated.

### 4. Install Overture Maps Package

- With the virtual environment activated, enter the following command in the cmd prompt to install the Overture Maps package.
    ```sql
    $ pip install overturemaps
    ```

### 5. Download Overture Maps Data

- With the virtual environment activated, download Overture Maps data by entering the following commands in the cmd prompt.
- Download Building data for Bangkok to khlongtoei_building.geojson file.
    ```sql
    $ overturemaps download --bbox=100.5507001257371797,13.6970007530963525,100.6016431134770528,13.7428667529314463 -f geojson --type=building -o khlongtoei_building.geojson
    ```

- Download transportation data for Bangkok to khlongtoei_transportation.geojson file.
    ```sql
    $ overturemaps download --bbox=100.5507001257371797,13.6970007530963525,100.6016431134770528,13.7428667529314463 -f geojson --type=segment -o khlongtoei_transportation.geojson
    ```

- Downloaded files will be saved in the directory where you created the virtual environment (C:\mago3d).

## :rocket: NASA DEM Download

### 1. Access NASA EARTHDATA

- Login is required.
- You must install the Earthdata Download app to download .tif files.

[search.earthdata.nasa.gov](https://search.earthdata.nasa.gov/search/granules?p=C1711961296-LPCLOUD&pg[0][v]=f&pg[0][gsk]=-start_date&as[science_keywords][0]=Land%20Surface%3ATopography%3ATerrain%20Elevation%3ADigital%20Elevation/Terrain%20Model%20(Dem)&tl=1723601365!3!!&fst0=Land%20Surface&fsm0=Topography&fs10=Terrain%20Elevation&fs20=Digital%20Elevation/Terrain%20Model%20(Dem))

### 2. Specify Area

- Use the tool on the right to specify the area you want to download.

![](../images/Training_Guide/Nasa_dem_area.png)

### 3. Download Data

- Download the data corresponding to the specified area.

![Nasa_dem_download](../images/Training_Guide/Nasa_dem_download.png)

## :telescope: Sentinel Image Download

### 1. Access Copernicus Data Space Ecosystem

- Login is required.

[Copernicus Data Space Ecosystem | Europe's eyes on Earth](https://dataspace.copernicus.eu/)

![Sentinel_home](../images/Training_Guide/Sentinel_home.png)

### 2. Set Data Search Conditions

- Move to the desired location and zoom in, then click the search button and adjust SENTINEL-2>MSI>L2A>Cloud Cover to 5%.

![Sentinel_search1](../images/Training_Guide/Sentinel_search1.png)

- Specify the date and click the Search button.

![Sentinel_search2](../images/Training_Guide/Sentinel_search2.png)

### 3. Download Data

- The list of searched images and the range of Sentinel images will appear on the screen.

![Sentinel_download1](../images/Training_Guide/Sentinel_download1.png)

- Once you have found the desired image, click the mouse button to download.

![Sentinel_download2](../images/Training_Guide/Sentinel_download2.png)

