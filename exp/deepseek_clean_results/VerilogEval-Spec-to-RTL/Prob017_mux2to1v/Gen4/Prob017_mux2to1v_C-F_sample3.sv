module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              sel,
    output [WIDTH-1:0] out
);

    // Parameterized width 2:1 multiplexer with optimal timing
    // Features:
    // - Simple ternary operator implementation for best synthesis results
    // - Parameterized width for reuse in different contexts
    // - Notes for system-level optimizations:
    //   * Consider clock gating if used in sequential logic
    //   * Implement operand isolation if inputs are stable during certain cycles
    //   * Use power gating if mux is inactive for long periods
    
    assign out = sel ? b : a;

endmodule