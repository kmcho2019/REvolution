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
    end

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude comparison (using subtraction)
    wire [N:0] diff = {1'b0, a[N-2:0]} - {1'b0, b[N-2:0]};
    wire a_gt_b = ~diff[N];

    // Operand preparation for addition/subtraction
    wire [N:0] b_operand = (a_sign ^ b_sign) ? ~{1'b0, b} + 1'b1 : {1'b0, b};
    wire [N:0] sum = {1'b0, a} + b_operand;

    // Result selection
    wire [N-1:0] magnitude = a_gt_b ? diff[N-1:0] : ~diff[N-1:0] + 1'b1;
    wire result_sign = (a_sign ^ b_sign) ? (a_gt_b ? a_sign : b_sign) : a_sign;

    // Overflow detection (only when signs match)
    wire overflow = (a_sign == b_sign) & (sum[N] != sum[N-1]);

    // Final result assembly with overflow saturation
    assign c = overflow ? 
               {a_sign, {N-1{~a_sign}}} :  // Saturate to max/min
               {result_sign, magnitude[N-2:0]};

endmodule