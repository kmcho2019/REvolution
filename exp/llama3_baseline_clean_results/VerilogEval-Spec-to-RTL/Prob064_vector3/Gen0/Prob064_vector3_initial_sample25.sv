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

    // Concatenate input vectors
    wire [29:0] concatenated_inputs = {a, b, c, d, e, f};

    // Pad with two 1 bits to make it a 32-bit vector
    wire [31:0] padded_inputs = {concatenated_inputs, 2'b11};

    // Split the padded vector into output vectors
    assign w = padded_inputs[31:24];
    assign x = padded_inputs[23:16];
    assign y = padded_inputs[15:8];
    assign z = padded_inputs[7:0];

endmodule