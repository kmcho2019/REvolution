module fixed_point_subtractor #(
    parameter integer Q = 8,  // Number of fractional bits
    parameter integer N = 16  // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-2:0] mag_a; // Magnitude of a excluding sign bit
    reg [N-2:0] mag_b; // Magnitude of b excluding sign bit
    reg sign_a;
    reg sign_b;
    reg [N-1:0] res;
    reg [N-1:0] sum_mag;
    reg [N-1:0] diff_mag;

    // Function to get magnitude from two's complement number
    function [N-2:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val[N-2:0]) + 1'b1;
            else
                abs_val = val[N-2:0];
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a = abs_val(a);
        mag_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: subtraction of magnitudes, sign same as inputs
            if (mag_a >= mag_b) begin
                diff_mag = mag_a - mag_b;
                res[N-1] = sign_a;
                res[N-2:0] = diff_mag[N-2:0];
            end else begin
                diff_mag = mag_b - mag_a;
                // Result sign is the same as inputs, but the larger magnitude's sign
                res[N-1] = sign_a; // sign_a == sign_b
                res[N-2:0] = diff_mag[N-2:0];
                // For subtraction, if mag_b > mag_a, sign flips in reality:
                // Because a - b, if mag_b > mag_a, result is negative of sign_a
                // Correcting sign:
                res[N-1] = ~sign_a; // flip sign
            end
        end else begin
            // Different signs: add magnitudes
            sum_mag = mag_a + mag_b;
            // Sign depends on which operand has larger magnitude
            if (mag_a >= mag_b)
                res[N-1] = sign_a;
            else
                res[N-1] = sign_b;
            res[N-2:0] = sum_mag[N-2:0];
        end

        // Handle zero result explicitly by checking magnitude part
        if (res[N-2:0] == 0)
            res[N-1] = 1'b0;

        c = res;
    end
endmodule