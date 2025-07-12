module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);

    // Conditional inversion for subtraction
    wire [N-1:0] b_operand = signs_equal ? b : ~b + 1'b1;

    // Single arithmetic operation
    wire [N:0] full_sum = {a[N-1], a} + {b_operand[N-1], b_operand};

    // Overflow detection (only when signs equal)
    wire overflow = signs_equal & (full_sum[N] ^ full_sum[N-1]);

    // Underflow detection (only when signs differ)
    wire underflow = ~signs_equal & (full_sum[N] ^ a_sign);

    // Result selection
    wire [N-1:0] saturated_result = 
        overflow  ? {a_sign, {N-1{~a_sign}}}
        : underflow ? {b_sign, {N-1{~b_sign}}}
        : full_sum[N-1:0];

    assign c = saturated_result;

endmodule