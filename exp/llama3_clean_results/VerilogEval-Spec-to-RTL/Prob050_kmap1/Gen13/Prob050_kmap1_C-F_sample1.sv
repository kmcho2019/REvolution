module TopModule(
    input a,
    input b,
    input c,
    output out
);

// The expression directly implements the required functionality in a simple manner.
assign out = a | b | c;

// Consider adding synthesis directives or constraints here to optimize for power, area, and timing.
// For example, to optimize for low power:
// `attribute power_optimize of TopModule : module is "low_power";

endmodule