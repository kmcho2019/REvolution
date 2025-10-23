module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total bits including sign bit
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value of signed N-bit number (two's complement)
    function [N-1:0] abs_val(input [N-1:0] in);
        begin
            abs_val = in[N-1] ? (~in + 1'b1) : in;
        end
    endfunction

    // Absolute values
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Determine which absolute value is greater or equal
    wire a_ge_b = (a_abs >= b_abs);

    // Result magnitude and sign
    wire [N-1:0] mag_sum;       // magnitude of result
    wire        res_sign;       // sign of result

    // If signs are same: add magnitudes
    wire [N:0] add_mag_ext = {1'b0, a_abs} + {1'b0, b_abs};

    // If signs differ: subtract smaller magnitude from larger
    wire [N-1:0] sub_mag = a_ge_b ? (a_abs - b_abs) : (b_abs - a_abs);

    // Assign result magnitude and sign based on signs of inputs
    assign mag_sum = (a_sign == b_sign) ? add_mag_ext[N-1:0] : sub_mag;

    assign res_sign = (a_sign == b_sign) 
                     ? a_sign 
                     : ( (a_ge_b) ? a_sign : b_sign );

    // Handle zero magnitude case: if magnitude is zero, force sign to zero
    wire mag_is_zero = (mag_sum == {N{1'b0}});
    wire final_sign = mag_is_zero ? 1'b0 : res_sign;

    // Assemble final result: sign bit + magnitude bits (two's complement)
    // Since mag_sum is magnitude (absolute value), convert to signed representation:
    // if sign==1 then take two's complement of mag_sum; else keep as is

    wire [N-1:0] mag_signed = final_sign ? (~mag_sum + 1'b1) : mag_sum;

    assign c = mag_signed;

endmodule