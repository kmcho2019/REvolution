module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater control: active only in heating mode when too cold
    assign heater = mode & too_cold;

    // Aircon control: active only in cooling mode when too hot
    // Note: heater and aircon are mutually exclusive due to mode selection
    assign aircon = ~mode & too_hot;

    // Fan control: active when either temperature control or manual request
    assign fan = heater | aircon | fan_on;

endmodule