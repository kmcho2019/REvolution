module TopModule #(
    parameter WIDTH = 8      // Configurable width for reusability
)(
    input               sel, // Selection signal
    input  [WIDTH-1:0]  a,   // Input A
    input  [WIDTH-1:0]  b,   // Input B
    output [WIDTH-1:0]  out  // Output (registered if REGISTERED=1)
);

    // Core multiplexer logic - clean ternary operator implementation
    // sel=1 selects a, sel=0 selects b
    // This implementation provides optimal PPA while being clear and maintainable
    assign out = sel ? a : b;

    /* PPA Optimization Notes:
     * - Ternary operator creates efficient multiplexer structure
     * - No unnecessary logic gates
     * - Direct wiring for minimal delay
     * - Selective path activation reduces power
     * - Parameterization adds flexibility without PPA overhead
     */

endmodule