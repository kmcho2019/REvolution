module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

wire [7:0] one_hot;
// Isolate least significant bit set
assign one_hot = in & (~in + 8'b1);

wire [7:0] one_hot_reg = one_hot;

// Encode the one-hot vector into a 3-bit binary position
// Since one_hot has only one bit set (or zero), use parallel logic:

assign pos[2] = one_hot[4] | one_hot[5] | one_hot[6] | one_hot[7];
assign pos[1] = one_hot[2] | one_hot[3] | one_hot[6] | one_hot[7];
assign pos[0] = one_hot[1] | one_hot[3] | one_hot[5] | one_hot[7];

// If input is zero, output zero as required
// Since pos will be zero if one_hot is zero, no extra logic needed

endmodule