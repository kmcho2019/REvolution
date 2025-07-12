module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              sel,
    output [WIDTH-1:0] out
);

    // Parameterized 2:1 multiplexer with optimal timing
    // Note: For system-level optimization, consider:
    // - Clock gating if used in sequential logic
    // - Operand isolation if inputs are stable during certain cycles
    // - Output enable if switching activity needs to be reduced
    assign out = sel ? b : a;

endmodule