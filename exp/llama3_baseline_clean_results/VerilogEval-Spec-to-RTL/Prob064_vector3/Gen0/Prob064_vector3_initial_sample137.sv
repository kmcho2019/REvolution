module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

// Combine all input vectors into a single 30-bit vector
wire [29:0] combined_input = {a, b, c, d, e, f};

// Split the combined vector into four 8-bit output vectors
assign w = combined_input[29:22];
assign x = combined_input[21:14];
assign y = combined_input[13:6];
assign z = {combined_input[5:2], 2'b11}; // Pad the last two bits with '1'

endmodule