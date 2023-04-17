SELECT temperature_2,
 relative_humidity_1,
  analog_in_3
FROM (
  SELECT temperature_2, relative_humidity_1, analog_in_3, ROW_NUMBER() OVER (ORDER BY received_at DESC) as row_num
  FROM firewatchsensordata_v3 
) t
WHERE row_num = 1
