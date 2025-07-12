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

    wire [WIDTH:0] sum;

    assign sum = do_sub ? {1'b0, a} + {1'b0, ~b} + 1 : {1'b0, a} + {1'b0, b};

    assign out = sum[WIDTH-1:0];
    assign result_is_zero = ~(| out);

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    adder_subtractor #(.WIDTH(8)) u_adder_subtractor (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule