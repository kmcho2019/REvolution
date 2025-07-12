module adder_subtractor (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_inv;
    assign b_inv = ~b;

    wire [7:0] b_two_complement;
    assign b_two_complement = b_inv + 1;

    wire [7:0] b_selector;
    assign b_selector = do_sub? b_two_complement : b;

    wire [7:0] sum;
    assign sum = a + b_selector;

    assign out = sum;
    assign result_is_zero = ~( |sum );

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    adder_subtractor u_adder_subtractor (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule