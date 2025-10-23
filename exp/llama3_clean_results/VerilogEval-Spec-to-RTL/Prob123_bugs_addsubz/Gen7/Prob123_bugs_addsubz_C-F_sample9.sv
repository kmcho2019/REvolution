module TopModule #
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

    wire [WIDTH-1:0] adder_in_b;

    // Multiplexer to select input to adder
    assign adder_in_b = do_sub? (~b + 1) : b;

    // Adder module
    assign out = a + adder_in_b;

    // Comparator module using direct comparison
    assign result_is_zero = (out == {WIDTH{1'b0}});

endmodule