module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: Check if each bit and its neighbor to the left are '1'
// Handle edge case for in[99]
assign out_both[99] = 1'b0;
assign out_both[98:0] = in[98:0] & in[99:1];

// out_any: Check if each bit or its neighbor to the right are '1'
// Handle edge case for in[0]
assign out_any[0] = 1'b0;
assign out_any[99:1] = in[99:1] | in[98:0];

// out_different: Check if each bit is different from its neighbor to the left
// Consider wrap-around for in[99]
assign out_different = in ^ ({in[0], in[99:1]});

endmodule