// Optimal parameterized XNOR gate with timing annotation
module TopModule #(
    parameter DELAY = 0  // Default zero delay
) (
    input a,
    input b,
    output out
);
    // Primary implementation: direct XNOR operator with parameterized delay
    assign #DELAY out = a ~^ b;

    // Timing specification for ASIC flows
    specify
        (a => out) = (DELAY);
        (b => out) = (DELAY);
    endspecify
endmodule