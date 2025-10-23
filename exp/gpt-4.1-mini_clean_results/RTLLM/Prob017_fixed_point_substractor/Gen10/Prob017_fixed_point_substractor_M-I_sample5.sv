module fixed_point_subtractor #(
    parameter Q = 8,          // Number of fractional bits
    parameter N = 16          // Total number of bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    // Internal registers for magnitude and sign
    reg [N-1:0] mag_a;
    reg [N-1:0] mag_b;
    reg [N-1:0] mag_res;
    reg        sign_a;
    reg        sign_b;
    reg        sign_res;
    reg [N-1:0] res;

    // Absolute value function
    function [N-1:0] abs_val(input signed [N-1:0] val);
        begin
            abs_val = val[N-1] ? (~val + 1'b1) : val;
        end
    endfunction

    always @* begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a  = abs_val(a);
        mag_b  = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if (mag_a >= mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res = mag_b - mag_a;
                sign_res = sign_a; // Same sign, so keep sign_a (as per spec)
            end
        end else begin
            // Different signs: add magnitudes
            mag_res = mag_a + mag_b;
            // Determine sign of result
            // If a positive and b negative
            if (sign_a == 1'b0 && sign_b == 1'b1) begin
                // sign depends on relative magnitude: if a > b then positive else negative
                sign_res = (mag_a >= mag_b) ? 1'b0 : 1'b1;
            end else begin
                // a negative, b positive
                // sign depends on relative magnitude: if b > a then positive else negative
                sign_res = (mag_b > mag_a) ? 1'b0 : 1'b1;
            end
        end

        // Reapply sign to magnitude to get two's complement result
        if (mag_res == 0) begin
            // Zero result: sign bit explicitly cleared
            res = {N{1'b0}};
        end else begin
            // Apply sign_res: if sign_res=1, negative, so two's complement magnitude
            res = sign_res ? (~mag_res + 1'b1) : mag_res;
        end
    end

    // Output register assignment
    always @* begin
        c = res;
    end

endmodule