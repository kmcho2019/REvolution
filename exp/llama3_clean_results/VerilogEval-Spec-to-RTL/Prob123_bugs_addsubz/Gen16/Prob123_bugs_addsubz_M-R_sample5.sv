module alu #
(
    parameter WIDTH = 8
)
(
    input logic do_sub,
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out,
    output logic result_is_zero
);

    assign out = do_sub ? (a - b) : (a + b);
    assign result_is_zero = (out == 0);

endmodule

module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
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