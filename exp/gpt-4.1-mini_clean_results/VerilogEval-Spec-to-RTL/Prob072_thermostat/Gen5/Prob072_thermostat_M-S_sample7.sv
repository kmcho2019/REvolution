module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    assign heater = mode & too_cold;
    assign aircon = (~mode) & too_hot;

    // Directly assign fan as OR of heater, aircon, and fan_on without intermediate wire
    assign fan = heater | aircon | fan_on;

endmodule