module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    assign heater = (mode == 1'b1) && (too_cold == 1'b1);
    assign aircon = (mode == 1'b0) && (too_hot == 1'b1);
    assign fan = (heater == 1'b1) || (aircon == 1'b1) || (fan_on == 1'b1);

endmodule