if (shakeIntensity > 0)
{
    view_xport[0] = irandom_range(shakeIntensity,-shakeIntensity)
    view_yport[0] = irandom_range(shakeIntensity,-shakeIntensity)
	
	camera_set_view_angle(view_camera[0], random_range(rotationIntensity,-rotationIntensity));
}
