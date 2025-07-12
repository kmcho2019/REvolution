module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Function: Compute absolute value of N-bit two's complement input
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            abs_val = val[N-1] ? (~val + 1'b1) : val;
        end
    endfunction

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Determine which operand has the larger absolute value
    wire a_ge_b = (abs_a >= abs_b);
    
    // Same sign: add absolute values
    wire [N-1:0] sum_abs = abs_a + abs_b;

    // Different signs: subtract smaller absolute value from larger absolute value
    wire [N-1:0] diff_abs = a_ge_b ? (abs_a - abs_b) : (abs_b - abs_a);

    // Decide whether signs are equal
    wire signs_equal = (a_sign == b_sign);

    // Determine result magnitude and sign
    wire [N-1:0] mag_result = signs_equal ? sum_abs : diff_abs;

    // Determine sign of the result for subtraction case
    wire result_sign_sub = a_ge_b ? a_sign : b_sign;

    // Determine result sign for addition case (same as a_sign and b_sign)
    wire result_sign_add = a_sign;

    // Final sign of the result
    wire result_sign = signs_equal ? result_sign_add : result_sign_sub;

    // Function to convert magnitude and sign back to two's complement number
    function [N-1:0] sign_mag_to_twos;
        input [N-1:0] magnitude;
        input         sign_bit;
        begin
            sign_mag_to_twos = sign_bit ? (~magnitude + 1'b1) : magnitude;
        end
    endfunction

    assign c = (mag_result == {N{1'b0}}) ? {N{1'b0}} : sign_mag_to_twos(mag_result, result_sign);

endmodule