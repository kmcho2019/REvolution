module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Generate priority masks
wire bit3_priority = in[3];
wire bit2_priority = in[2] & ~in[3];
wire bit1_priority = in[1] & ~in[3] & ~in[2];
wire bit0_priority = in[0] & ~in[3] & ~in[2] & ~in[1];

// Binary encoding from priority masks
assign pos[1] = bit3_priority | bit2_priority;
assign pos[0] = bit3_priority | bit1_priority;

endmodule