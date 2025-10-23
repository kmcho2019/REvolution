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

module adder_subtractor #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output logic result_is_zero
);
    wire [WIDTH-1:0] b_comp;
    twos_component #(.WIDTH(WIDTH)) u_twos_comp (.a(b), .out(b_comp));

    wire [WIDTH-1:0] add_result;
    assign add_result = a + b;

    wire [WIDTH-1:0] sub_result;
    assign sub_result = a + b_comp;

    assign out = do_sub ? sub_result : add_result;
    assign result_is_zero = (out == 0); // Simplified condition for zero flag
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