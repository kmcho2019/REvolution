module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand a
    input  wire [N-1:0] b,            // Fixed-point input operand b
    output reg  [N-1:0] c             // Fixed-point output result c
);

    // Local signals for magnitude (absolute values) extraction
    reg [N-2:0] a_mag;
    reg [N-2:0] b_mag;
    reg [N-1:0] sum_mag;   // For addition, width increased by 1 bit to hold carry
    reg [N-2:0] diff_mag;
    reg sign_res;

    // Function: Convert two's complement input to magnitude (unsigned)
    function [N-2:0] twos_complement_to_mag;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0) begin
                // Positive number, magnitude is value without sign bit
                twos_complement_to_mag = val[N-2:0];
            end else begin
                // Negative number: two's complement magnitude
                twos_complement_to_mag = (~val[N-2:0]) + 1'b1;
            end
        end
    endfunction

    // Function: Convert magnitude and sign to two's complement output
    function [N-1:0] mag_and_sign_to_twos_complement;
        input [N-2:0] mag;
        input sign_bit;
        reg [N-1:0] temp;
        begin
            if (sign_bit == 1'b0) begin
                // Positive number: sign bit zero + magnitude
                temp = {1'b0, mag};
            end else begin
                // Negative number: two's complement of magnitude
                temp = {1'b1, (~mag + 1'b1)};
            end
            mag_and_sign_to_twos_complement = temp;
        end
    endfunction

    // Compare magnitudes
    function abs_gte;
        input [N-2:0] x;
        input [N-2:0] y;
        begin
            abs_gte = (x >= y);
        end
    endfunction

    always @(*) begin
        // Extract magnitudes of inputs a and b
        a_mag = twos_complement_to_mag(a);
        b_mag = twos_complement_to_mag(b);

        if (a[N-1] == b[N-1]) begin
            // Same sign: add magnitudes
            // Use wider addition to catch carry out
            sum_mag = {1'b0, a_mag} + {1'b0, b_mag};
            sign_res = a[N-1];  // sign stays the same as inputs

            // If sum_mag exceeds magnitude bits, saturate or truncate accordingly
            // The problem does not specify saturation, so truncate LSB bits if needed
            // Just take lower N-1 bits as magnitude, ignore overflow
            c = mag_and_sign_to_twos_complement(sum_mag[N-2:0], sign_res);
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            if (abs_gte(a_mag, b_mag)) begin
                diff_mag = a_mag - b_mag;
                sign_res = (diff_mag == 0) ? 1'b0 : a[N-1];
                c = mag_and_sign_to_twos_complement(diff_mag, sign_res);
            end else begin
                diff_mag = b_mag - a_mag;
                sign_res = (diff_mag == 0) ? 1'b0 : b[N-1];
                c = mag_and_sign_to_twos_complement(diff_mag, sign_res);
            end
        end
    end

endmodule