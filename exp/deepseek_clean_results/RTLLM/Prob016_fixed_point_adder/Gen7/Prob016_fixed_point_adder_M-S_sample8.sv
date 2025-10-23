module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    wire [N-1:0] sum;
    wire overflow;

    // Main addition with overflow detection
    assign {overflow, sum} = a + b;

    // Saturation logic
    assign c = (overflow && !a[N-1]) ? {1'b0, {(N-1){1'b1}}} :  // Positive overflow
              (overflow && a[N-1])  ? {1'b1, {(N-1){1'b0}}} :  // Negative overflow
              sum;

endmodule