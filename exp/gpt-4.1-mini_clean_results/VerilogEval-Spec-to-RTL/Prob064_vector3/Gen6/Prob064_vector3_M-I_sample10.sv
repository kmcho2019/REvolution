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

    wire [29:0] concat_inputs = {a, b, c, d, e, f};
    wire [31:0] concat_full = {concat_inputs, 2'b11};

    assign w = concat_full[31:24];
    assign x = concat_full[23:16];
    assign y = concat_full[15:8];
    assign z = concat_full[7:0];

endmodule