module cla_adder #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input carry_in,
    output [WIDTH-1:0] sum,
    output carry_out
);

    assign {carry_out, sum} = a + b + carry_in;

endmodule

module addsub_zflag #
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

    wire [WIDTH-1:0] b_invert;
    assign b_invert = do_sub? ~b : b;

    wire carry_in;
    assign carry_in = do_sub? 1'b1 : 1'b0;

    wire [WIDTH-1:0] sum;
    wire carry_out;

    cla_adder #(.WIDTH(WIDTH)) u_cla (
       .a(a),
       .b(b_invert),
       .carry_in(carry_in),
       .sum(sum),
       .carry_out(carry_out)
    );

    assign out = sum;
    assign result_is_zero = ~(| sum);

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    addsub_zflag #(.WIDTH(8)) u_addsub (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule