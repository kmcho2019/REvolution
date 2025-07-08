module TopModule(
    input  mode,      // 1 = heating, 0 = cooling
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater_w;
    wire aircon_w;
    wire fan_w;

    assign heater_w = (mode == 1'b1) && too_cold;
    assign aircon_w = (mode == 1'b0) && too_hot;
    assign fan_w = heater_w || aircon_w || fan_on;

    assign heater = heater_w;
    assign aircon = aircon_w;
    assign fan = fan_w;

endmodule