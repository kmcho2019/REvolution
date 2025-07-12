module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_comp; // two's complement of b when do_sub is 1, b when do_sub is 0
    assign b_comp = do_sub ? (~b + 1) : b;

    // Adder module
    assign out = a + b_comp;

    // Comparator module using direct comparison
    assign result_is_zero = (out == 8'd0);

endmodule