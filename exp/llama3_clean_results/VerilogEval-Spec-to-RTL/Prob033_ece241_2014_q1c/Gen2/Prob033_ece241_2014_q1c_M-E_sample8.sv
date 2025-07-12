module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [7:0] sum;
    wire carry_out;

    assign {carry_out, sum} = a + b;

    assign s = sum;
    assign overflow = carry_out;

endmodule