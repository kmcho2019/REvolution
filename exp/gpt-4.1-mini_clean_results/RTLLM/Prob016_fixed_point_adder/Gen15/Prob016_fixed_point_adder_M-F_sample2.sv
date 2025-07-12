module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal function: compute absolute value of N-bit two's complement number
    function [N-2:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val[N-2:0];
            else
                abs_val = (~val[N-2:0] + 1'b1);
        end
    endfunction

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    wire [N-2:0] mag_a = abs_val(a);
    wire [N-2:0] mag_b = abs_val(b);

    wire a_ge_b = (mag_a >= mag_b);

    // Intermediate magnitude sum and difference with extra bit to avoid overflow
    wire [N-1:0] mag_sum  = {1'b0, mag_a} + {1'b0, mag_b};
    wire [N-1:0] mag_diff = a_ge_b ? ({1'b0, mag_a} - {1'b0, mag_b}) : ({1'b0, mag_b} - {1'b0, mag_a});

    // Compute result combinationally
    wire [N-1:0] res = (sign_a == sign_b) ? (
                          // Same sign: add magnitudes and keep sign
                          {sign_a, mag_sum[N-2:0]}
                      ) : (
                          // Different signs: subtract smaller magnitude from larger
                          (mag_diff == 0) ? {1'b0, {(N-1){1'b0}}} : (
                              a_ge_b ? (
                                  sign_a == 1'b0 ? {1'b0, mag_diff[N-2:0]} : {1'b1, (~mag_diff[N-2:0] + 1'b1)}
                              ) : (
                                  sign_b == 1'b0 ? {1'b0, mag_diff[N-2:0]} : {1'b1, (~mag_diff[N-2:0] + 1'b1)}
                              )
                          )
                      );

    assign c = res;

endmodule