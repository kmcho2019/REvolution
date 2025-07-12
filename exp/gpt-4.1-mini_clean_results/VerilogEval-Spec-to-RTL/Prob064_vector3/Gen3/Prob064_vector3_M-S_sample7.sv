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

    wire [31:0] all_inputs = {a, b, c, d, e, f, 2'b11};

    assign w = all_inputs[31:24];
    assign x = all_inputs[23:16];
    assign y = all_inputs[15:8];
    assign z = all_inputs[7:0];

endmodule