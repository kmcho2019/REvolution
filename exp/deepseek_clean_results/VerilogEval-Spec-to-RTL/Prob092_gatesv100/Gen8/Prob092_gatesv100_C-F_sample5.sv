module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: vector operation with explicit edge case
    assign out_both[99] = 1'b0;  // MSB has no left neighbor
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: vector operation with explicit edge case
    assign out_any[0] = 1'b0;    // LSB has no right neighbor
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: optimized wrap-around with XOR
    wire [99:0] left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ left_neighbor;

endmodule