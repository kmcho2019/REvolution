module parallel_prefix_adder #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

    wire [WIDTH-1:0] sum;
    assign sum = a + b;
    assign out = sum;

endmodule

module zero_flag_detector #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    output result_is_zero
);

    assign result_is_zero = ~(| a);

endmodule

module operation_selector #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] b_selector
);

    assign b_selector = do_sub ? (~b + 1) : b;

endmodule

module alu #
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

    wire [WIDTH-1:0] b_selector;
    operation_selector #(.WIDTH(WIDTH)) u_selector (
        .do_sub(do_sub),
        .b(b),
        .b_selector(b_selector)
    );

    parallel_prefix_adder #(.WIDTH(WIDTH)) u_adder (
        .a(a),
        .b(b_selector),
        .out(out)
    );

    zero_flag_detector #(.WIDTH(WIDTH)) u_detector (
        .a(out),
        .result_is_zero(result_is_zero)
    );

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    alu #(.WIDTH(8)) u_alu (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule