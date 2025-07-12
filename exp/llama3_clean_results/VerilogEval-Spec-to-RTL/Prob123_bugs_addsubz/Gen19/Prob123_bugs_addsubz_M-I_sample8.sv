module addsub_cla_zflag #
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

    assign out = a + b_selector;
    assign result_is_zero = ~(| out);

endmodule

module TopModule (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    addsub_cla_zflag #(.WIDTH(8)) u_addsub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule