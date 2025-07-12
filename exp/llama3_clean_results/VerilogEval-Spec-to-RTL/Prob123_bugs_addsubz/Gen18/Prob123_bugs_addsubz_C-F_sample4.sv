module twos_complement #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    output [WIDTH-1:0] out
);

    assign out = ~a + 1;

endmodule

module ripple_carry_adder #
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

module alu #
(
    parameter WIDTH = 8
)
(
    input logic do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out,
    output logic result_is_zero
);

    wire [WIDTH-1:0] b_selector;
    assign b_selector = do_sub ? (~b + 1) : b;

    ripple_carry_adder #(.WIDTH(WIDTH)) u_adder (
        .a(a),
        .b(b_selector),
        .out(out)
    );

    assign result_is_zero = ~(| out);

endmodule

module TopModule (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    alu #(.WIDTH(8)) u_alu (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule