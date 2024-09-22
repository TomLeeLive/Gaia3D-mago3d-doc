const viewer = new Cesium.Viewer('cesiumContainer');
viewer.scene.globe.depthTestAgainstTerrain = true;

const resource_3d = './assets/3dtiles/tileset.json'
const resource_2d = 'mago3d:coverage_00a0f46b4b3becbc2f3ca9a4b19b5618';
const resource_terrain = './assets/terrain/'

// 3d
Cesium.Cesium3DTileset.fromUrl(resource_3d)
    .then(model => {
        viewer.scene.primitives.add(model);
        //viewer.zoomTo(model);
    });

// 2d
const imageLayer = new Cesium.ImageryLayer(
    new Cesium.WebMapServiceImageryProvider({
        url: 'https://mdtp.gaia3d.com/geoserver/wms',
        layers: resource_2d,
        minimumLevel: 0,
        parameters: {
            service: "WMS",
            version: "1.1.1",
            request: "GetMap",
            transparent: "true",
            format: "image/png",
            tiled: true,
        },
    }),
);
viewer.scene.imageryLayers.add(imageLayer);

// terrain
viewer.terrainProvider = await Cesium.CesiumTerrainProvider.fromUrl(resource_terrain);

const bangkok = {lat: 13.730276, lng: 100.560534}
const bangkokBtn = document.getElementById("bangkok-btn");

const flyToPosition = (viewer, position) => {
    const alt = 50000;
    viewer.camera.flyTo({
        destination: Cesium.Cartesian3.fromDegrees(position.lng, position.lat, alt)
    })
}

bangkokBtn.addEventListener("click", () => flyToPosition(viewer, bangkok));