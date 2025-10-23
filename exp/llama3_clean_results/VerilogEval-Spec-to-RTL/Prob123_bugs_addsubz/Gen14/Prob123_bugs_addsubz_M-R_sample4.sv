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

    always @(*) begin
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
        endcase

        result_is_zero = ~(| out);
    end

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