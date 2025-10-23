module TopModule (
    input  mode,       // 1: heating, 0: cooling
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Select active device based on mode and temperature
    wire active_heater = (mode == 1'b1) ? too_cold : 1'b0;
    wire active_aircon = (mode == 1'b0) ? too_hot  : 1'b0;

    assign heater = active_heater;
    assign aircon = active_aircon;

    // Fan is on if heater or aircon active, or if user requests fan_on
    assign fan = (active_heater | active_aircon) | fan_on;

endmodule