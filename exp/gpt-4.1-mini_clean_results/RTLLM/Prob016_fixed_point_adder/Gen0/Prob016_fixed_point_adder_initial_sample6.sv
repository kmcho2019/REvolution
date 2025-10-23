module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);
    // Internal registers
    reg [N-2:0] a_mag, b_mag;   // Magnitudes of a and b (N-1 bits)
    reg a_sign, b_sign;         // Sign bits
    reg [N-1:0] a_abs, b_abs;   // Absolute values of a and b (N bits for computation)
    reg [N-1:0] sum;            // Sum of magnitudes (N bits)
    reg [N-1:0] diff;           // Difference of magnitudes (N bits)
    reg [N-2:0] res_mag;        // Result magnitude (N-1 bits)
    reg res_sign;               // Result sign

    // Function to compute absolute value of signed input in two's complement
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1; // Two's complement
            else
                abs_val = val;
        end
    endfunction

    always @(*) begin
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Compute absolute values
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        // Remove sign bit to get magnitudes (N-1 bits)
        a_mag = a_abs[N-2:0];
        b_mag = b_abs[N-2:0];

        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            sum = {1'b0, a_mag} + {1'b0, b_mag}; // Extend to N bits for addition
            res_sign = a_sign;

            // Handle potential overflow by saturating at max magnitude if needed
            // Since sum is N bits, if sum[N-1] == 1 it means overflow
            if (sum[N-1] == 1'b1) begin
                // Saturate to max positive magnitude if sign=0, or max negative magnitude if sign=1
                if (res_sign == 1'b0) begin
                    res_mag = {(N-1){1'b1}}; // Max positive magnitude: all ones except sign
                end else begin
                    res_mag = {(N-1){1'b0}}; // For negative, zero magnitude but sign set means minimum number
                end
            end else begin
                res_mag = sum[N-2:0];
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_abs >= b_abs) begin
                diff = {1'b0, a_mag} - {1'b0, b_mag};
                res_sign = a_sign; // Sign of the operand with larger magnitude
                res_mag = diff[N-2:0];
            end else begin
                diff = {1'b0, b_mag} - {1'b0, a_mag};
                res_sign = b_sign;
                res_mag = diff[N-2:0];
            end
        end

        // Compose result: sign bit + magnitude
        // Special case: if result magnitude is zero, set sign to 0 (positive zero)
        if (res_mag == 0) begin
            res_sign = 1'b0;
        end

        c = {res_sign, res_mag};
    end
endmodule