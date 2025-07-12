module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Assign heater and aircon based on mode and temperature
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;

    // Turn on fan when heater or aircon is on, or fan_on is requested
    assign fan = heater | aircon | fan_on;

endmodule