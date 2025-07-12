module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_invert;
    assign b_invert = do_sub? ~b : b;

    wire carry_in;
    assign carry_in = do_sub? 1'b1 : 1'b0;

    assign out = a + b_invert + carry_in;
    assign result_is_zero = ~(| out);

endmodule