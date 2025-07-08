module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater control: only active in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon control: only active in cooling mode when too hot
    assign aircon = ~mode & too_hot;

    // Fan control: on when heater or aircon is on, or when explicitly requested
    assign fan = heater | aircon | fan_on;

endmodule