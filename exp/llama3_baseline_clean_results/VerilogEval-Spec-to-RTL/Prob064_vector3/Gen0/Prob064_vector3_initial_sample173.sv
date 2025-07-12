module TopModule(
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    wire [29:0] combined_input;  // 30-bit vector to hold the concatenated input
    wire [31:0] combined_output;  // 32-bit vector to hold the input concatenated with two 1 bits

    assign combined_input = {a, b, c, d, e, f};  // Concatenate the input vectors
    assign combined_output = {combined_input, 2'b11};  // Append two 1 bits to the combined input

    // Split the combined output into the four 8-bit output vectors
    assign w = combined_output[31:24];
    assign x = combined_output[23:16];
    assign y = combined_output[15:8];
    assign z = combined_output[7:0];

endmodule