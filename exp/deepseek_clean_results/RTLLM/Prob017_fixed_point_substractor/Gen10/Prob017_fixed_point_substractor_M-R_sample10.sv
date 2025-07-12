module fixed_point_subtractor #(
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Direct N-bit subtraction
    wire [N-1:0] result;
    assign result = a - b;
    
    // Overflow occurs when signs don't match and result sign differs from a's sign
    assign overflow = (a[N-1] ^ b[N-1]) & (a[N-1] ^ result[N-1]);
    
    // Zero detection using reduction OR (more synthesis-friendly)
    wire is_zero;
    assign is_zero = ~(|result);
    
    // Final output (zero handling is implicit in two's complement)
    assign c = result;

endmodule