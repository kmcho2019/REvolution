module TopModule (
    input  mode,      // 1=heating, 0=cooling
    input  too_cold,  // Temperature too low
    input  too_hot,   // Temperature too high  
    input  fan_on,    // Manual fan request
    output heater,    // Heater control
    output aircon,    // Air conditioner control
    output fan        // Fan control
);

    // Heating mode: activate heater when too cold
    assign heater = mode & too_cold;

    // Cooling mode: activate aircon when too hot
    assign aircon = ~mode & too_hot;

    // Fan control: activate when heating/cooling or manual request
    assign fan = heater | aircon | fan_on;

endmodule