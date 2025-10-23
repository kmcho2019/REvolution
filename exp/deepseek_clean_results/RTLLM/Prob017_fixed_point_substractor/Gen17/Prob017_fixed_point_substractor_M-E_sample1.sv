module fixed_point_subtractor #(
    parameter Q = 16,
    parameter N = 32
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Early sign comparison
    wire signs_equal = ~(a_sign ^ b_sign);

    // Dual-path processing
    wire [N-1:0] same_sign_res;
    wire [N-1:0] diff_sign_res;

    // Same sign path (direct subtraction)
    assign same_sign_res = {a_sign, a_mag} - {b_sign, b_mag};

    // Different sign path (absolute addition with sign determination)
    wire [N-1:0] abs_sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire larger_mag = (a_mag > b_mag);
    assign diff_sign_res = {a_sign ^ ~larger_mag, abs_sum[N-2:0]};

    // Result selection
    wire [N-1:0] raw_result = signs_equal ? same_sign_res : diff_sign_res;

    // Optimized zero detection (parallel reduction)
    wire is_zero = ~(|raw_result[N-2:0]);
    
    // Final result with zero handling
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : raw_result;

    // Optional: Leading-one detector for optimized comparison
    // function [N-1:0] leading_one;
    // input [N-1:0] val;
    // begin
    //     leading_one = {N{1'b0}};
    //     for (integer i = N-1; i >= 0; i = i-1)
    //         if (val[i]) begin
    //             leading_one[i] = 1'b1;
    //             break;
    //         end
    // end
    // endfunction

endmodule