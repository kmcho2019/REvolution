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

module carry_lookahead_adder #
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

    reg [WIDTH-1:0] sum_reg;
    reg carry_out_reg;

    always @(*) begin
        {carry_out_reg, sum_reg} = a + b + carry_in;
    end

    assign sum = sum_reg;
    assign carry_out = carry_out_reg;

endmodule

module zero_detection #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    output reg result_is_zero
);

    assign result_is_zero = ~(| a);

endmodule

module alu #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    wire [WIDTH-1:0] b_selector;
    twos_complement #(.WIDTH(WIDTH)) u_twos_comp (
        .a(b),
        .out(b_selector)
    );

    assign b_selector = do_sub ? b_selector : b;

    wire carry_in;
    assign carry_in = do_sub ? 1'b1 : 1'b0;

    wire [WIDTH-1:0] sum;
    wire carry_out;
    carry_lookahead_adder #(.WIDTH(WIDTH)) u_cla (
        .a(a),
        .b(b_selector),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    assign out = sum;

    zero_detection #(.WIDTH(WIDTH)) u_zero_det (
        .a(sum),
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