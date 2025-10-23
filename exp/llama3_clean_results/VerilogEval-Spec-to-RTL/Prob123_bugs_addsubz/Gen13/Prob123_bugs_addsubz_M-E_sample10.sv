module carry_lookahead_adder #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

    assign out = a + b;

endmodule

module subtractor #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

    assign out = a - b;

endmodule

module zero_detection #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] in,
    output out
);

    assign out = ~(|in);

endmodule

module hybrid_adder_subtractor #
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
    assign b_selector = do_sub? (~b + 1) : b;

    carry_lookahead_adder #(.WIDTH(WIDTH)) u_adder (
       .a(a),
       .b(b_selector),
       .out(out)
    );

    zero_detection #(.WIDTH(WIDTH)) u_zero_detection (
       .in(out),
       .out(result_is_zero)
    );

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    hybrid_adder_subtractor #(.WIDTH(8)) u_hybrid_adder_subtractor (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule