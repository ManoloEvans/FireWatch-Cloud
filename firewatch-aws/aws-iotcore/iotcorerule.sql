SELECT 
    end_device_ids.device_id, 
    uplink_message.decoded_payload.analog_in_3, 
    uplink_message.decoded_payload.gps_7.latitude, 
    uplink_message.decoded_payload.gps_7.longitude, 
    uplink_message.decoded_payload.relative_humidity_1, 
    uplink_message.decoded_payload.temperature_2, 
    received_at 
FROM 'lorawan/#'