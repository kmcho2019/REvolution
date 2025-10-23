module TopModule (
    input mode,           // 1=heating mode, 0=cooling mode
    input too_cold,       // Temperature is too cold
    input too_hot,        // Temperature is too hot
    input fan_on,         // Manual fan override
    output heater,        // Heater control
    output aircon,        // Air conditioner control
    output fan            // Fan control
);

    // Direct control signals based on mode and temperature
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Optimized fan control: 
    // (active heating/cooling condition) OR manual request
    assign fan = (mode ? too_cold : too_hot) | fan_on;

endmodule