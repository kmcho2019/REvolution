/*
 * KMapXor - Implements checkerboard Karnaugh map pattern using optimal XOR chain
 * K-map:
 *             ab
 *    cd   00  01  11  10
 *    00 | 0 | 1 | 0 | 1 |
 *    01 | 1 | 0 | 1 | 0 |
 *    11 | 0 | 1 | 0 | 1 |
 *    10 | 1 | 0 | 1 | 0 |
 */
module KMapXor #(
    parameter OPTIMIZE_XOR_CHAIN = 1
) (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // synthesis translate_off
    if (OPTIMIZE_XOR_CHAIN) begin
        // synthesis attribute use_xor_chain of this module is "yes"
    end
    // synthesis translate_on

    assign out = a ^ b ^ c ^ d;

endmodule