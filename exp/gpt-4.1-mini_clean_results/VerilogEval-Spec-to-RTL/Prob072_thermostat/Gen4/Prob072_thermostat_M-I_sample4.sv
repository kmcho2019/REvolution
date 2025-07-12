module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    // Direct assignments for heater and aircon
    assign heater = mode & too_cold;
    assign aircon = (~mode) & too_hot;

    // Combine heater and aircon to control fan along with fan_on
    wire heating_or_cooling = heater | aircon;
    assign fan = heating_or_cooling | fan_on;

endmodule