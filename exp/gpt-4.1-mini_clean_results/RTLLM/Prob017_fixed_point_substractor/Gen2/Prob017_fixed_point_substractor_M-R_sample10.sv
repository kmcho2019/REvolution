module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function: absolute value for two's complement fixed-point number
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            abs_val = val[N-1] ? (~val + 1'b1) : val;
        end
    endfunction

    // Function: return 1 if a >= b (both unsigned), else 0
    function a_ge_b(input [N-1:0] a_mag, input [N-1:0] b_mag);
        begin
            a_ge_b = (a_mag >= b_mag);
        end
    endfunction

    // Compute absolute values
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Compute magnitude sum for different sign cases
    wire [N-1:0] sum_mag = a_abs + b_abs;

    // Compute magnitude difference and comparison
    wire a_abs_ge_b_abs = a_ge_b(a_abs, b_abs);
    wire [N-1:0] diff_mag = a_abs_ge_b_abs ? (a_abs - b_abs) : (b_abs - a_abs);

    // Result magnitude and sign wires for different cases
    wire [N-1:0] same_sign_res = a - b;

    wire [N-1:0] diff_sign_res_pos; // positive result when different signs
    wire [N-1:0] diff_sign_res_neg; // negative result when different signs

    // For positive result, just sum of magnitudes
    assign diff_sign_res_pos = sum_mag;

    // For negative result, two's complement of sum_mag
    assign diff_sign_res_neg = (~sum_mag) + 1'b1;

    // Result for different sign cases:
    // If a positive and b negative:
    //   sign positive if |a| >= |b| else negative
    // If a negative and b positive:
    //   sign negative if |a| >= |b| else positive
    wire [N-1:0] diff_sign_res = (a_sign == 1'b0 && b_sign == 1'b1) ?
                                (a_abs_ge_b_abs ? diff_sign_res_pos : diff_sign_res_neg) :
                                (a_sign == 1'b1 && b_sign == 1'b0) ?
                                (a_abs_ge_b_abs ? diff_sign_res_neg : diff_sign_res_pos) :
                                {N{1'b0}}; // should not happen

    // Final combinational result:
    // If signs equal: subtract normally
    // Else: use diff_sign_res computed above
    wire [N-1:0] raw_res = (a_sign == b_sign) ? same_sign_res : diff_sign_res;

    // Check zero to force sign bit zero
    wire zero_res = (raw_res == {N{1'b0}});

    // If zero, clear sign bit to zero; else keep raw result as is
    // This is done by forcing MSB=0 if zero, else original MSB
    assign c = zero_res ? {1'b0, raw_res[N-2:0]} : raw_res;

endmodule