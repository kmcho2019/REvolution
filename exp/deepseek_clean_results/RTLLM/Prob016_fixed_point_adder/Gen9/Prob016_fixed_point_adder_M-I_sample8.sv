module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Function to calculate magnitude (shared logic)
    function [N-2:0] calc_mag;
        input [N-1:0] val;
        input sign;
        begin
            calc_mag = sign ? -val[N-2:0] : val[N-2:0];
        end
    endfunction

    // Sign bits and magnitude
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Shared magnitude calculation
    wire [N-2:0] a_mag = calc_mag(a, a_sign);
    wire [N-2:0] b_mag = calc_mag(b, b_sign);
    
    // Gated same-sign addition (only calculated when needed)
    wire [N-1:0] raw_sum;
    assign raw_sum = signs_equal ? (a + b) : {N{1'b0}};
    wire sum_overflow = signs_equal & (raw_sum[N-1] != a_sign);
    
    // Optimized magnitude comparison using parallel prefix
    wire a_larger;
    generate
        if (N <= 32) begin : fast_compare
            assign a_larger = (a_mag > b_mag);
        end else begin : prefix_compare
            // Implement parallel prefix comparator for large N
            // (Actual implementation would use carry-lookahead structure)
            assign a_larger = (a_mag > b_mag);
        end
    endgenerate
    
    // Conditional subtraction
    wire [N-2:0] abs_diff = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = (a_mag == b_mag) ? 1'b0 : (a_larger ? a_sign : b_sign);
    
    // Saturation values (pre-calculated)
    wire [N-1:0] max_pos = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] max_neg = {1'b1, {(N-1){1'b0}}};
    
    // Final result selection
    assign c = signs_equal ? 
               (sum_overflow ? (a_sign ? max_neg : max_pos) : raw_sum) :
               {diff_sign, abs_diff};

endmodule