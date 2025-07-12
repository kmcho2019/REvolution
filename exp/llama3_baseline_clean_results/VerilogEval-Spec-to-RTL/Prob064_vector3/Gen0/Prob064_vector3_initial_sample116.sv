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

    // Concatenate the input vectors
    wire [29:0] concatenated_inputs = {a, b, c, d, e, f};

    // Append two 1 bits to the end
    wire [31:0] concatenated_with_ones = {concatenated_inputs, 2'b11};

    // Split the 32-bit vector into the output vectors
    assign w = concatenated_with_ones[31:24];
    assign x = concatenated_with_ones[23:16];
    assign y = concatenated_with_ones[15:8];
    assign z = concatenated_with_ones[7:0];

endmodule