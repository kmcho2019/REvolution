module fixed_point_adder #(
    parameter integer N = 16,       // Total bits including sign
    parameter integer Q = 8         // Fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Internal registers for sign bits and magnitudes
    reg a_sign, b_sign, res_sign;
    reg [N-2:0] a_mag, b_mag;       // Magnitude excluding sign bit
    reg [N-1:0] res_mag;             // Result magnitude can be up to N bits (for addition overflow)

    // Internal register to hold final magnitude truncated to N-1 bits
    reg [N-2:0] res_mag_trunc;

    // Temporary variables for magnitude comparison and operations
    reg a_gt_b;                     // a magnitude > b magnitude

    // Extract sign and magnitude for inputs (two's complement to absolute)
    function [N-2:0] abs_mag(input [N-1:0] val);
        reg [N-1:0] val_signed;
    begin
        val_signed = val;
        if (val_signed[N-1] == 1'b1) // negative
            abs_mag = (~val + 1'b1)[N-2:0]; // take two's complement magnitude excluding sign bit
        else
            abs_mag = val[N-2:0];
    end
    endfunction

    always @(*) begin
        // Extract sign bits
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Get absolute magnitudes
        a_mag = abs_mag(a);
        b_mag = abs_mag(b);

        // Initialize
        res_sign = 1'b0;
        res_mag = {N{1'b0}};
        res_mag_trunc = {N-1{1'b0}};

        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            res_mag = {1'b0, a_mag} + {1'b0, b_mag};  // width N bits to catch overflow
            // If overflow in magnitude addition, the MSB is discarded naturally
            // Assign sign same as inputs
            res_sign = a_sign;

            // Truncate result magnitude to N-1 bits (discard extra carry)
            res_mag_trunc = res_mag[N-2:0];
        end else begin
            // Different sign: subtract smaller magnitude from larger
            a_gt_b = (a_mag > b_mag);
            if (a_mag == b_mag) begin
                // Result is zero
                res_sign = 1'b0; // positive zero
                res_mag_trunc = {N-1{1'b0}};
            end else if (a_gt_b) begin
                // Result sign is sign of a
                res_sign = a_sign;
                res_mag_trunc = a_mag - b_mag;
            end else begin
                // Result sign is sign of b
                res_sign = b_sign;
                res_mag_trunc = b_mag - a_mag;
            end
        end

        // Compose final result from sign and magnitude
        c = {res_sign, res_mag_trunc};
    end

endmodule