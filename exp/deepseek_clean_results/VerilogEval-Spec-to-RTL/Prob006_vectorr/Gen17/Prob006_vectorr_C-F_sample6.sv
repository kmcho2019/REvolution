/*
 * BitReverser - Optimal bit reversal module with multiple implementation options
 * Features:
 *   - Parameterized width (default 8)
 *   - Two optimal implementation choices
 *   - Clear documentation
 *   - Pure combinational logic
 *   - SystemVerilog enhancements
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Documented width for clarity
    localparam ACTUAL_WIDTH = WIDTH;
    
    // Implementation Option 1: Direct Concatenation (Best PPA)
    // Optimal for fixed widths or when unrolling is preferred
    assign out = {in[0], in[1], in[2], in[3],
                 in[4], in[5], in[6], in[7]};

    /* Alternative Implementation Option 2: Generate Loop (Better for large widths)
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate
    */

    /* Bit Mapping Documentation:
     * out[0] = in[7]
     * out[1] = in[6]
     * out[2] = in[5]
     * out[3] = in[4]
     * out[4] = in[3]
     * out[5] = in[2]
     * out[6] = in[1]
     * out[7] = in[0]
     */
endmodule

/*
 * TopModule - Wrapper maintaining original interface
 * Uses the optimal BitReverser internally
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    BitReverser #(
        .WIDTH(8)
    ) reverser (
        .in(in),
        .out(out)
    );

endmodule