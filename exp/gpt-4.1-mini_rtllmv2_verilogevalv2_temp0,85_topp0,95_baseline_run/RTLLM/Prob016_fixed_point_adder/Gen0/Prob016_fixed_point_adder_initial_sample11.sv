module fixed_point_adder #(
    parameter integer Q = 8,  // Number of fractional bits
    parameter integer N = 16  // Total bits (including sign bit)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to store the result magnitude and sign
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to get absolute value of two's complement number
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    // Compare magnitudes
    wire [N-1:0] a_mag = abs_val(a);
    wire [N-1:0] b_mag = abs_val(b);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            // sum might be N bits + 1, but we keep N bits (wrap around)
            reg [N:0] sum_ext;
            sum_ext = {1'b0, a_mag} + {1'b0, b_mag};

            // If overflow in magnitude addition, it wraps naturally in two's complement
            // Set sign bit same as inputs
            if (sum_ext[N] == 1'b1) begin
                // Overflow: wrapping in two's complement
                res = sum_ext[N-1:0];
            end else begin
                res = sum_ext[N-1:0];
            end

            // Set sign bit accordingly
            res[N-1] = a_sign;

            // Convert magnitude back to two's complement with sign
            if (a_sign == 1'b1) begin
                // Negative: two's complement of magnitude
                res = (~res + 1'b1) & ((1 << N) - 1);
            end
            // else positive: res is magnitude with sign bit zero (already set)
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag >= b_mag) begin
                // res magnitude = a_mag - b_mag
                reg [N-1:0] diff;
                diff = a_mag - b_mag;
                // sign = a_sign (which is 1'b0 for positive or 1'b1 for negative)
                if (diff == 0) begin
                    // Result zero
                    res = {N{1'b0}};
                end else begin
                    res = diff;
                    // If sign is negative, convert magnitude to two's complement
                    if (a_sign == 1'b1) begin
                        res = (~res + 1'b1) & ((1 << N) - 1);
                    end else begin
                        // positive sign, res as is
                    end
                end
            end else begin
                // res magnitude = b_mag - a_mag
                reg [N-1:0] diff;
                diff = b_mag - a_mag;
                if (diff == 0) begin
                    res = {N{1'b0}};
                end else begin
                    res = diff;
                    // If sign is negative, convert magnitude to two's complement
                    if (b_sign == 1'b1) begin
                        res = (~res + 1'b1) & ((1 << N) - 1);
                    end else begin
                        // positive sign, res as is
                    end
                end
            end
        end

        // Assign to output
        c = res;
    end

endmodule