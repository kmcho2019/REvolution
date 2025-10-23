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
    wire [29:0] input_concat = {a, b, c, d, e, f};

    // Concatenate two 1 bits at the end to get a total of 32 bits
    wire [31:0] input_concat_extended = {input_concat, 2'b11};

    // Split the 32-bit vector into four 8-bit output vectors
    assign w = input_concat_extended[31:24];
    assign x = input_concat_extended[23:16];
    assign y = input_concat_extended[15:8];
    assign z = input_concat_extended[7:0];

endmodule