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

    wire [29:0] input_concat;
    wire [31:0] input_with_ones;
    assign input_concat = {a, b, c, d, e, f};
    assign input_with_ones = {input_concat, 2'b11};
    assign w = input_with_ones[31:24];
    assign x = input_with_ones[23:16];
    assign y = input_with_ones[15:8];
    assign z = input_with_ones[7:0];

endmodule