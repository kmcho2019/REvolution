// Define the alu module
module alu (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Select between normal input and two's complement
    wire [7:0] b_selector;
    assign b_selector = do_sub? (~b + 1) : b;

    // Perform addition or subtraction
    assign out = a + b_selector;

    // Generate zero flag efficiently
    assign result_is_zero = (out == 0);

endmodule