SELECT t1.* FROM firewatchsensordata_v3 t1
  JOIN (SELECT device_id, MAX(received_at) received_at FROM firewatchsensordata_v3 GROUP BY device_id) t2
    ON t1.device_id = t2.device_id AND t1.received_at = t2.received_at;