module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Perform addition or subtraction based on control signal
    assign out = do_sub ? (a - b) : (a + b);

    // Generate zero flag using bitwise NOR operation
    assign result_is_zero = ~(| out);

endmodule