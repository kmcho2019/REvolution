module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits
    parameter integer N = 16           // Total bits width including sign bit
)(
    input  wire [N-1:0] a,             // Fixed-point signed input operand a
    input  wire [N-1:0] b,             // Fixed-point signed input operand b
    output reg  [N-1:0] c              // Fixed-point signed output result
);

    // Internal register to hold final two's complement result
    reg [N-1:0] res;

    // Extract sign bits (MSB)
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute value of two's complement number (N bits)
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1;  // two's complement negation
            else
                abs_val = val;
        end
    endfunction

    // Function to convert sign bit and magnitude back to two's complement
    function [N-1:0] to_twos_complement(input [N-1:0] mag, input sign);
        begin
            if (sign == 1'b1)
                to_twos_complement = (~mag) + 1'b1;
            else
                to_twos_complement = mag;
        end
    endfunction

    // Function to compare absolute magnitudes: returns 1 if a_abs >= b_abs, else 0
    function cmp_abs_ge(input [N-1:0] a_abs, input [N-1:0] b_abs);
        begin
            cmp_abs_ge = (a_abs >= b_abs) ? 1'b1 : 1'b0;
        end
    endfunction

    // Registers for absolute values
    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;

    // Registers for intermediate magnitude results
    reg [N:0] sum_abs;         // N+1 bits to accommodate carry out
    reg [N-1:0] diff_abs;
    reg sign_res;
    reg [N-1:0] mag_res;

    always @* begin
        // Compute absolute values of inputs
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: Add magnitudes with carry bit
            sum_abs = {1'b0, a_abs} + {1'b0, b_abs};
            // Truncate to N bits, carry beyond range is discarded (wrap-around)
            mag_res = sum_abs[N-1:0];
            // Result sign same as input signs
            sign_res = sign_a;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (cmp_abs_ge(a_abs, b_abs)) begin
                diff_abs = a_abs - b_abs;
                mag_res = diff_abs;
                // If result is zero, sign is zero (positive)
                sign_res = (diff_abs == 0) ? 1'b0 : sign_a;
            end else begin
                diff_abs = b_abs - a_abs;
                mag_res = diff_abs;
                sign_res = (diff_abs == 0) ? 1'b0 : sign_b;
            end
        end

        // Convert magnitude and sign back to two's complement fixed-point format
        res = to_twos_complement(mag_res, sign_res);

        // Output assignment
        c = res;
    end

endmodule