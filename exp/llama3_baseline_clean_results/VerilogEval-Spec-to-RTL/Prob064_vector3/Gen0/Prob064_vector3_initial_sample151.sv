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

    wire [29:0] concatenated_inputs;
    assign concatenated_inputs = {a, b, c, d, e, f};
    wire [31:0] concatenated_output;
    assign concatenated_output = {concatenated_inputs, 2'b11};

    assign w = concatenated_output[31:24];
    assign x = concatenated_output[23:16];
    assign y = concatenated_output[15:8];
    assign z = concatenated_output[7:0];

endmodule