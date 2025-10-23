module TopModule (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Calculate two's complement of b when do_sub is high
    wire [7:0] b_selector = do_sub? (~b + 1) : b;

    // Perform addition or subtraction
    assign out = a + b_selector;

    // Generate zero flag
    assign result_is_zero = ~(| out);

endmodule