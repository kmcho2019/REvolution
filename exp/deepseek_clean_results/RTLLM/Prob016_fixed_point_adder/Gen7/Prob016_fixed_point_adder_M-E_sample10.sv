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

    // Sign-magnitude conversion
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Parallel arithmetic operations
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};  // Extra bit for overflow
    wire [N-1:0] diff_ab = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N-1:0] diff_ba = {1'b0, b_mag} - {1'b0, a_mag};

    // Magnitude comparison (using subtraction result)
    wire a_gt_b = ~diff_ab[N-1];
    wire b_gt_a = ~diff_ba[N-1];

    // Operation selection signals
    wire same_sign = ~(a_sign ^ b_sign);
    wire add_ops = same_sign;
    wire sub_ops = ~same_sign;

    // Intermediate results
    wire [N-1:0] add_result = sum;
    wire [N-1:0] sub_result = a_gt_b ? diff_ab : diff_ba;
    wire sub_sign = a_gt_b ? a_sign : b_sign;

    // Overflow detection (only relevant for addition)
    wire overflow = add_ops & sum[N-1];

    // Final result assembly
    wire [N-2:0] final_mag = add_ops ? 
                            (overflow ? {N-1{1'b1}} : add_result[N-2:0]) :
                            sub_result[N-2:0];
    
    wire final_sign = add_ops ? a_sign : sub_sign;

    assign c = {final_sign, final_mag};

    // Rounding logic (optional)
    // wire round_bit = final_mag[0] & (|final_mag[Q-1:0]);
    // assign c = {final_sign, final_mag[N-2:1] + round_bit};

endmodule