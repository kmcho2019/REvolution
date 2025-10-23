module TopModule(
    input  [3:0] in,
    output [3:0] out_both, 
    output [3:0] out_any,  
    output [3:0] out_different
);

// We don't care about out_both[3] and out_any[0], so let's assign them to 0
assign out_both[3] = 1'b0;
assign out_any[0] = 1'b0;

// Assign values to out_both and out_any
assign out_both[2:0] = {in[2] & in[3], in[1] & in[2], in[0] & in[1]};
assign out_any[3:1] = {in[2] | in[3], in[1] | in[2], in[0] | in[1]};

// Correctly assign values to out_different, considering the wrap-around for all bits
assign out_different[3] = in[3] ^ in[0]; // in[3] with its left neighbour in[0]
assign out_different[2] = in[2] ^ in[3]; // in[2] with its left neighbour in[3]
assign out_different[1] = in[1] ^ in[2]; // in[1] with its left neighbour in[2]
assign out_different[0] = in[0] ^ in[3]; // in[0] with its left neighbour in[3]

endmodule