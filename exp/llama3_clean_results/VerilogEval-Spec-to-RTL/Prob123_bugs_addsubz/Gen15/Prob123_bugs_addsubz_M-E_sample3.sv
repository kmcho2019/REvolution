module adder_subtractor #
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

    logic [WIDTH:0] sum;
    logic [WIDTH:0] diff;

    assign sum = a + b;
    assign diff = a - b;

    assign out = do_sub? diff[WIDTH-1:0] : sum[WIDTH-1:0];
    assign result_is_zero = ~(| out);

endmodule

module TopModule (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    adder_subtractor #(.WIDTH(8)) u_adder_subtractor (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule