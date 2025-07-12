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
    wire [29:0] input_concat;
    assign input_concat = {a, b, c, d, e, f};

    // Append two 1 bits
    wire [31:0] output_concat;
    assign output_concat = {input_concat, 2'b11};

    // Split output vector
    assign w = output_concat[31:24];
    assign x = output_concat[23:16];
    assign y = output_concat[15:8];
    assign z = output_concat[7:0];

endmodule