module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater_int, aircon_int;

    assign heater_int = mode & too_cold;
    assign aircon_int = (~mode) & too_hot;

    assign heater = heater_int;
    assign aircon = aircon_int;
    assign fan = heater_int | aircon_int | fan_on;

endmodule