module twos_complement #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    output [WIDTH-1:0] out
);

    // Using the same efficient two's complement calculation
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
    output result_is_zero
);

    wire [WIDTH-1:0] b_comp;
    twos_complement #(.WIDTH(WIDTH)) u_twos_comp (.a(b), .out(b_comp));

    wire [WIDTH-1:0] add_result;
    assign add_result = a + b;

    wire [WIDTH-1:0] sub_result;
    assign sub_result = a + b_comp;

    // Maintaining the same multiplexer logic for selecting between addition and subtraction results
    assign out = do_sub ? sub_result : add_result;
    
    // The result_is_zero flag calculation remains efficient
    assign result_is_zero = ~( | out);

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Instantiating the adder_subtractor module with the same parameters
    adder_subtractor #(.WIDTH(8)) u_adder_subtractor (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule