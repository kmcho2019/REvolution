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

    wire [29:0] concatenated_input; // To hold the concatenated 30-bit input
    wire [31:0] output_vector;      // To hold the 32-bit output vector

    // Concatenate the 5-bit input vectors into a single 30-bit vector
    assign concatenated_input = {a, b, c, d, e, f};

    // Concatenate the 30-bit input vector with "11" to make a 32-bit vector
    assign output_vector = {concatenated_input, 2'b11};

    // Assign the 32-bit output vector to the four 8-bit output ports
    assign w = output_vector[31:24];
    assign x = output_vector[23:16];
    assign y = output_vector[15:8];
    assign z = output_vector[7:0];

endmodule