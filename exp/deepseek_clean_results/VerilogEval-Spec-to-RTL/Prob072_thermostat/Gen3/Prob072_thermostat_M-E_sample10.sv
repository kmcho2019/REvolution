module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Mode decoding
    wire heating_mode = mode;
    wire cooling_mode = ~mode;

    // Temperature control signals
    wire need_heating = heating_mode & too_cold;
    wire need_cooling = cooling_mode & too_hot;

    // Output assignments
    assign heater = need_heating;
    assign aircon = need_cooling;
    assign fan = need_heating | need_cooling | fan_on;

endmodule