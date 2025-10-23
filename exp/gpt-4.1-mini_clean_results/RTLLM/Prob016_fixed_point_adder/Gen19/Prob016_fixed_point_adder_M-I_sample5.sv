module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total bits (including sign)
)(
    input  wire [N-1:0] a,       // Fixed-point input a (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input b (two's complement)
    output wire [N-1:0] c        // Fixed-point sum output (two's complement)
);

    // Internal signals for sign and magnitude
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to get absolute value from two's complement
    // Returns magnitude as unsigned [N-1:0] but top bit always zero because we keep magnitude
    function [N-1:0] abs_val(input [N-1:0] in);
        begin
            abs_val = sign_a ? (~in + 1'b1) : in;
        end
    endfunction

    wire [N-1:0] mag_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] mag_b = sign_b ? (~b + 1'b1) : b;

    // Wider magnitude addition with carry
    wire [N:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};

    // Magnitude subtraction (always mag_a >= mag_b checked outside)
    wire [N-1:0] mag_diff_ab = mag_a - mag_b;
    wire [N-1:0] mag_diff_ba = mag_b - mag_a;

    // Result wires
    reg sign_res;
    reg [N-1:0] mag_res;

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            mag_res = mag_sum[N-1:0];
            sign_res = sign_a;
        end else begin
            // Different signs: subtract smaller from larger
            if (mag_a == mag_b) begin
                // Result zero
                mag_res = {N{1'b0}};
                sign_res = 1'b0;
            end else if (mag_a > mag_b) begin
                mag_res = mag_diff_ab;
                sign_res = sign_a; // sign of operand with larger magnitude
            end else begin
                mag_res = mag_diff_ba;
                sign_res = sign_b;
            end
        end
    end

    // Compose two's complement output from sign and magnitude
    // If sign = 1 => negate magnitude to two's complement
    assign c = (sign_res == 1'b0) ? mag_res : (~mag_res + 1'b1);

endmodule