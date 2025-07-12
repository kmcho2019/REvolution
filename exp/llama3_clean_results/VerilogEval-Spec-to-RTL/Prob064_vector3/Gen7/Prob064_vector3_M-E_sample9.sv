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

    wire [29:0] input_vector; // 30-bit vector to hold the concatenated inputs
    wire [31:0] extended_vector; // 32-bit vector to hold the inputs plus two '1' bits

    // Concatenate the input vectors into a single 30-bit vector
    assign input_vector = {a, b, c, d, e, f};

    // Extend the 30-bit vector by appending two '1' bits
    assign extended_vector = {input_vector, 2'b11};

    // Assign the output vectors from the extended vector
    assign w = extended_vector[31:24]; // Bits 31-24
    assign x = extended_vector[23:16]; // Bits 23-16
    assign y = extended_vector[15:8]; // Bits 15-8
    assign z = extended_vector[7:0]; // Bits 7-0

endmodule