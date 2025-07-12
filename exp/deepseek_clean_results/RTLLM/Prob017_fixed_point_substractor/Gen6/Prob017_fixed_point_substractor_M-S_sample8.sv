module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c,
    output wire overflow
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
    end

    // Main subtraction
    wire signed [N-1:0] raw_diff = a - b;
    
    // Overflow occurs when signs of inputs differ and result sign differs from a's sign
    assign overflow = (a[N-1] != b[N-1]) && (raw_diff[N-1] != a[N-1]);
    
    // Zero handling - explicitly set to 0 when result is zero
    assign c = (raw_diff == 0) ? 0 : raw_diff;

endmodule