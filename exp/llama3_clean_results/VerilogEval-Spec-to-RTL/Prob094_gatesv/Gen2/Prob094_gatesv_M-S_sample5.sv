module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

// Assign out_both with correct bit width, setting the MSB to 0 since it's not needed
assign out_both = {1'b0, in[2:0] & in[3:2]};

// Assign out_any with correct logic
assign out_any = {in[3:1] | in[2:0], 1'b0};

// Maintain the existing logic for out_different
assign out_different = {in[3:0] ^ {in[0], in[3:1]}};

endmodule