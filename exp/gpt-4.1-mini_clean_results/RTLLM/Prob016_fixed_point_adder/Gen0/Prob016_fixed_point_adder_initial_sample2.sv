module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers
    reg [N-2:0] a_mag;    // magnitude of a (excluding sign bit)
    reg [N-2:0] b_mag;    // magnitude of b (excluding sign bit)
    reg        a_sign;    // sign bit of a
    reg        b_sign;    // sign bit of b

    reg [N-1:0] sum_mag;  // for addition result magnitude + carry
    reg [N-1:0] diff_mag; // for subtraction result magnitude

    reg        res_sign;  // sign bit of result
    reg [N-2:0] res_mag; // magnitude bits of result
    reg        mag_zero; // zero magnitude flag

    integer i;

    // Function: compute absolute value magnitude of two's complement number
    function [N-2:0] abs_mag;
        input [N-1:0] val;
        reg   [N-1:0] val_neg;
        begin
            if (val[N-1] == 1'b0) begin
                abs_mag = val[N-2:0];
            end else begin
                // two's complement negation
                val_neg = (~val) + 1;
                abs_mag = val_neg[N-2:0];
            end
        end
    endfunction

    // Compare magnitudes: returns 1 if a > b
    function mag_greater;
        input [N-2:0] a_m;
        input [N-2:0] b_m;
        integer idx;
        begin
            mag_greater = 0;
            for (idx = N-2; idx >= 0; idx = idx - 1) begin
                if (a_m[idx] > b_m[idx]) begin
                    mag_greater = 1;
                    disable for_loop_exit;
                end else if (a_m[idx] < b_m[idx]) begin
                    mag_greater = 0;
                    disable for_loop_exit;
                end
            end
        end
    endfunction

    // Add two magnitudes (N-1 bits: N-1 bits magnitude)
    // sum_mag has N bits to hold carry out
    function [N:0] add_mag;
        input [N-1:0] a_mag_ext;
        input [N-1:0] b_mag_ext;
        reg   [N:0] result;
        begin
            result = a_mag_ext + b_mag_ext;
            add_mag = result;
        end
    endfunction

    always @* begin
        a_sign = a[N-1];
        b_sign = b[N-1];
        a_mag  = abs_mag(a);
        b_mag  = abs_mag(b);

        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            // Extend to N bits with 0 MSB to avoid overflow in addition
            // sum_mag is N bits wide to catch carry out
            sum_mag = {1'b0, a_mag} + {1'b0, b_mag}; // N bits

            // If sum_mag MSB (bit N-1) is set, overflow beyond N-1 bits magnitude.
            // Since we're limited to N-1 bits magnitude, overflow bits truncated
            // Overflow handling: saturate or wrap around
            // Here, truncate overflow bit by dropping MSB beyond N-1
            // Truncate: take lower N-1 bits (sum_mag[N-1:0])

            res_sign = a_sign;
            res_mag  = sum_mag[N-1:1]; // take lower N-1 bits ignoring carry out bit 0 which is LSB?

            // Correction: sum_mag is N bits: sum_mag[N-1:0]
            // Lower bits are sum_mag[N-2:0], MSB sum_mag[N-1] is overflow bit

            // Actually bits: sum_mag[N-1] is MSB (carry out), sum_mag[N-2:0] magnitude

            res_mag = sum_mag[N-2:0]; // take N-1 bits magnitude

            // No additional carry-in or out bit used here
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            // Determine which magnitude is greater
            if (mag_greater(a_mag, b_mag)) begin
                // a_mag > b_mag => res = a_mag - b_mag, sign = a_sign
                diff_mag = a_mag - b_mag;
                res_sign = a_sign;
                res_mag  = diff_mag;
            end else if (mag_greater(b_mag, a_mag)) begin
                // b_mag > a_mag => res = b_mag - a_mag, sign = b_sign
                diff_mag = b_mag - a_mag;
                res_sign = b_sign;
                res_mag  = diff_mag;
            end else begin
                // magnitudes equal => result zero
                res_sign = 1'b0;
                res_mag  = { (N-1) {1'b0} };
            end
        end

        // Check zero magnitude: if all zeros
        mag_zero = 1'b1;
        for (i=0; i < N-1; i=i+1) begin
            if (res_mag[i] == 1'b1)
                mag_zero = 1'b0;
        end

        if (mag_zero) begin
            // Zero magnitude, set sign zero (positive zero)
            res_sign = 1'b0;
        end

        // Reconstruct two's complement output from sign and magnitude:
        if (res_sign == 1'b0) begin
            // positive number: c = 0 + magnitude
            c = {1'b0, res_mag};
        end else begin
            // negative number: c = two's complement of magnitude
            // two's complement = (~{0,res_mag}) + 1
            // Here, we must form full N-bit two's complement number from magnitude and sign
            // Compose magnitude in N bits (with 0 MSB), then negate
            c = (~{1'b0, res_mag}) + 1;
        end
    end

endmodule