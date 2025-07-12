module TopModule #(
    parameter WIDTH = 8      // Configurable data width
) (
    input              sel,  // Selector: 1->a, 0->b
    input  [WIDTH-1:0] a,    // First input bus
    input  [WIDTH-1:0] b,    // Second input bus
    output [WIDTH-1:0] out   // Output bus
);

    /*
     * Core multiplexer implementation:
     * - Uses ternary operator for optimal synthesis
     * - Single-level selection minimizes delay
     * - Width-matched for clean synthesis
     * - Parameterized for reuse across designs
     */
    assign out = sel ? a : b;

endmodule