module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    assign heater = mode ? too_cold : 0;
    assign aircon = !mode ? too_hot : 0;
    assign fan = fan_on || heater || aircon;

endmodule