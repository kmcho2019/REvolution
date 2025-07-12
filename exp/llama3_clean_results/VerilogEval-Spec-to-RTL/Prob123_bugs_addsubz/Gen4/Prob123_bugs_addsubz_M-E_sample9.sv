module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] adder_in_b;

    // Multiplexer to select input to adder
    assign adder_in_b = do_sub ? (~b + 1) : b;

    // Adder module
    assign out = a + adder_in_b;

    // Comparator module
    assign result_is_zero = (out == 8'd0);

endmodule