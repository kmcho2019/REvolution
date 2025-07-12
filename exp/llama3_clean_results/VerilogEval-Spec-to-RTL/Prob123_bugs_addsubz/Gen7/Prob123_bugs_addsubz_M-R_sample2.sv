module alu #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output reg result_is_zero
);

    wire [WIDTH-1:0] b_selector;
    assign b_selector = do_sub ? (~b + 1) : b;

    assign out = a + b_selector;
    assign result_is_zero = (out == {WIDTH{1'b0}});

endmodule