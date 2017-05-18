import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

RenderTargetSelector {
    id: offscreenLayer
    target: rt

    property alias renderTarget: rt
    property alias width: rt.width
    property alias height: rt.height

    Layer { id: sceneLayerOpaque }
    Layer { id: sceneLayerTrans }

    Scene {
        targetLayerOpaque: sceneLayerOpaque
        targetLayerTrans: sceneLayerTrans
        FirstPersonCameraController { camera: sceneCamera }
    }

    TextureRenderTarget {
        id: rt
    }

    Viewport {
        normalizedRect: Qt.rect(0, 0, 1, 1)
        CameraSelector {
            id: cameraSelector
            camera: Camera {
                id: sceneCamera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                aspectRatio: rt.width / rt.height
                position: Qt.vector3d( 0.0, 0.0, 40.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
            }
            RenderPassFilter {
                matchAny: [ FilterKey { name: "pass"; value: "opaque" } ]
                ClearBuffers {
                    clearColor: Qt.rgba(0, 0.5, 1, 1)
                    buffers: ClearBuffers.ColorDepthBuffer
                    FrustumCulling {
                        LayerFilter {
                            layers: [ sceneLayerOpaque ]
                        }
                    }
                }
            }
            RenderPassFilter {
                matchAny: [ FilterKey { name: "pass"; value: "transparent" } ]
                SortPolicy {
                    sortTypes: [ SortPolicy.BackToFront ]
                    FrustumCulling {
                        LayerFilter {
                            layers: [ sceneLayerTrans ]
                        }
                    }
                }
            }
        }
    }
}