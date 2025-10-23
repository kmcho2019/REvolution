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

// Concatenate all input vectors into a single 30-bit vector
wire [29:0] concatenated_vector = {a, b, c, d, e, f};

// Append two 1 bits to the end of the concatenated vector
wire [31:0] output_vector = {concatenated_vector, 2'b11};

// Split the output vector into four 8-bit vectors
assign w = output_vector[31:24];
assign x = output_vector[23:16];
assign y = output_vector[15:8];
assign z = output_vector[7:0];

endmodule