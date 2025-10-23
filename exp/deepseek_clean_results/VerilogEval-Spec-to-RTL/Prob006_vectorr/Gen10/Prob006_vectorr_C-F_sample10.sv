/*
 * BitReverser - Parameterized bit reversal module
 * Features:
 *   - Pure combinational logic for optimal timing
 *   - Direct bit reversal for minimal delay
 *   - Parameterized width for flexibility (default 8)
 *   - Clear documentation and systematic bit ordering
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal assignment for optimal PPA
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule

/*
 * TopModule - Maintains original 8-bit interface
 * Uses the parameterized BitReverser internally
 * Ports:
 *   in  - 8-bit input [7:0]
 *   out - 8-bit reversed output [7:0]
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate the parameterized bit reverser
    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule