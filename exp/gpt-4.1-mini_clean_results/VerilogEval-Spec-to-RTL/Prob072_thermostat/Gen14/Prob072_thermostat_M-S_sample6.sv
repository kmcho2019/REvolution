module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater = mode & too_cold;
    wire aircon = ~mode & too_hot;

    assign fan = heater | aircon | fan_on;

    assign heater = heater;
    assign aircon = aircon;

endmodule