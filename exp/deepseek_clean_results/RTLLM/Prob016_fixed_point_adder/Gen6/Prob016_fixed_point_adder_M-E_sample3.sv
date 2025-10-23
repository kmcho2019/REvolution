module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Constants for saturation
    localparam MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam MAX_NEG = {1'b1, {(N-1){1'b0}}};
    localparam INT_BITS = N-Q-1;  // Integer bits (excluding sign)

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Early sign prediction
    wire signs_equal = (a_sign == b_sign);
    wire a_larger = (a_mag > b_mag);
    wire result_sign = signs_equal ? a_sign : (a_larger ? a_sign : b_sign);

    // Magnitude processing - split into integer and fractional parts
    wire [INT_BITS-1:0] a_int = a_mag[N-2:Q];
    wire [INT_BITS-1:0] b_int = b_mag[N-2:Q];
    wire [Q-1:0] a_frac = a_mag[Q-1:0];
    wire [Q-1:0] b_frac = b_mag[Q-1:0];

    // Carry-select addition for integer part
    wire [INT_BITS:0] int_sum_c0, int_sum_c1;
    wire [INT_BITS:0] int_diff_c0, int_diff_c1;
    
    // Compute both carry scenarios in parallel
    assign int_sum_c0 = {1'b0, a_int} + {1'b0, b_int};
    assign int_sum_c1 = {1'b0, a_int} + {1'b0, b_int} + 1'b1;
    
    assign int_diff_c0 = {1'b0, a_int} - {1'b0, b_int};
    assign int_diff_c1 = {1'b0, a_int} - {1'b0, b_int} - 1'b1;

    // Fractional addition (no carry-select needed)
    wire [Q:0] frac_sum = {1'b0, a_frac} + {1'b0, b_frac};
    wire [Q:0] frac_diff = a_larger ? ({1'b0, a_frac} - {1'b0, b_frac}) : 
                                    ({1'b0, b_frac} - {1'b0, a_frac});

    // Final carry resolution and operation selection
    wire [INT_BITS:0] int_result;
    wire [Q:0] frac_result;
    wire carry_out;
    
    if (signs_equal) begin
        // Addition case
        wire frac_carry = frac_sum[Q];
        assign int_result = frac_carry ? int_sum_c1 : int_sum_c0;
        assign frac_result = frac_sum;
        assign carry_out = int_result[INT_BITS];
    end else begin
        // Subtraction case
        wire frac_borrow = (a_larger ? (a_frac < b_frac) : (b_frac < a_frac));
        assign int_result = frac_borrow ? int_diff_c1 : int_diff_c0;
        assign frac_result = frac_diff;
        assign carry_out = 1'b0; // No overflow in subtraction
    end

    // Overflow detection (considering fractional bits)
    wire overflow = signs_equal & 
                   ((a_int[INT_BITS-1] & b_int[INT_BITS-1]) |
                   (carry_out & ~result_sign);

    // Result composition
    wire [N-2:0] magnitude = overflow ? 
                            (result_sign ? MAX_NEG[N-2:0] : MAX_POS[N-2:0]) :
                            {int_result[INT_BITS-1:0], frac_result[Q-1:0]};

    // Final output with sign
    assign c = {result_sign, magnitude};

endmodule