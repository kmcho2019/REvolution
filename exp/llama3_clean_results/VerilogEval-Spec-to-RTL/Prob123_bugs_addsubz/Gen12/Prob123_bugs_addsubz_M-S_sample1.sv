// Define the ALU module as the top-level entity
module TopModule #
(
    parameter WIDTH = 8
)
(
    input logic do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output logic result_is_zero
);

    // Perform addition or subtraction
    assign out = do_sub? (a - b) : (a + b);

    // Generate zero flag
    assign result_is_zero = ~(| out);

endmodule