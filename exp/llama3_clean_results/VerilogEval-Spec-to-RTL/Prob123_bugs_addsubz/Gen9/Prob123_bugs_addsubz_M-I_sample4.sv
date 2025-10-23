module adder_subtractor #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output result_is_zero
);

    assign out = do_sub ? (a - b) : (a + b);
    assign result_is_zero = (out == 0);

endmodule