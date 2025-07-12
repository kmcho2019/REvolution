/**
 * TopModule - Structural 8-bit Register with Synchronous Reset
 * 
 * Features:
 * - Structural implementation using primitives
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered operation
 * - Synchronous active-high reset
 * - Explicit bit-wise implementation
 */

// D Flip-Flop with synchronous reset (UDP)
primitive DFF_SR (q, clk, reset, d);
    output q;
    input clk, reset, d;
    reg q;

    table
        // clk  reset  d  :  q  :  q+
        (01)    0      0   :  ?  :  0;  // Clock rising, no reset
        (01)    0      1   :  ?  :  1;
        (01)    1      ?   :  ?  :  0;  // Reset has priority
        (0?)    ?      ?   :  ?  :  -;  // No change on non-rising clock
        ?       ?      ?   :  ?  :  -;  // No change otherwise
    endtable
endprimitive

module TopModule #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] d,
    output [DATA_WIDTH-1:0] q
);

    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : dff_array
            DFF_SR dff_inst (
                .q(q[i]),
                .clk(clk),
                .reset(reset),
                .d(d[i])
            );
        end
    endgenerate

endmodule