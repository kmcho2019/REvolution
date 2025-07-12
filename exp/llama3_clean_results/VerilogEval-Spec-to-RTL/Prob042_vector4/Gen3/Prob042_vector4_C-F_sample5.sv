module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

// Use a conditional statement to decide the fill value for the upper 24 bits
wire [23:0] fill_vector = (in[7] == 1'b1)? {24{1'b1}} : {24{1'b0}};

// Concatenate the fill vector with the input to sign-extend it
assign out = {fill_vector, in};

endmodule