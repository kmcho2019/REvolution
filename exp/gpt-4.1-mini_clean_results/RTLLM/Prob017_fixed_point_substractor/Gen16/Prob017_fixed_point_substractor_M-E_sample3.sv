`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign bit)
    parameter integer Q = 8    // Fractional bits count
)(
    input  wire signed [N-1:0] a,   // Input a in two's complement fixed-point
    input  wire signed [N-1:0] b,   // Input b in two's complement fixed-point
    output reg  signed [N-1:0] c    // Output c = a - b in two's complement fixed-point
);

    // Internal registers for sign and magnitude extraction
    reg a_sign;
    reg b_sign;

    reg [N-2:0] a_mag; // magnitude width = N-1 (exclude sign bit)
    reg [N-2:0] b_mag;

    // For intermediate result in sign-magnitude
    reg res_sign;
    reg [N-2:0] res_mag;

    // Auxiliary variables for comparison and operation
    reg mag_geq;  // a_mag >= b_mag

    // Convert two's complement input to sign-magnitude
    // Note: sign = MSB, magnitude = abs(value)
    // magnitude computed via conditional inversion and adding 1 if negative
    
    // Function to convert two's complement to magnitude
    function [N-2:0] twos_comp_to_mag;
        input signed [N-1:0] val;
        reg [N-2:0] abs_val;
        begin
            if (val[N-1] == 1'b0) begin
                // positive number: magnitude is bits [N-2:0] as-is
                twos_comp_to_mag = val[N-2:0];
            end else begin
                // negative number: take two's complement of val[N-2:0]
                abs_val = (~val[N-2:0]) + 1'b1;
                twos_comp_to_mag = abs_val;
            end
        end
    endfunction

    always @(*) begin
        // Extract signs
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Extract magnitudes (absolute values)
        a_mag = twos_comp_to_mag(a);
        b_mag = twos_comp_to_mag(b);

        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            // Determine which magnitude is larger for result sign and subtraction order
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                res_mag = b_mag - a_mag;
                // Result sign same as inputs' sign, but subtraction reversed means negation
                // Since both inputs have same sign, flipping sign because result is negative
                res_sign = ~a_sign;  
            end
        end else begin
            // Different signs: add magnitudes
            res_mag = a_mag + b_mag;

            // Result sign is sign of operand with larger magnitude
            if (a_mag > b_mag) begin
                res_sign = a_sign;
            end else if (b_mag > a_mag) begin
                res_sign = b_sign;
            end else begin
                // Equal magnitudes, result is zero
                res_sign = 1'b0; // force zero sign bit to 0
                res_mag = { (N-1){1'b0} };
            end
        end

        // If magnitude is zero, clear sign bit as per requirement
        if (res_mag == { (N-1){1'b0} })
            res_sign = 1'b0;

        // Convert back from sign-magnitude to two's complement
        if (res_sign == 1'b0) begin
            // Positive result: sign bit 0, magnitude as is
            c = {1'b0, res_mag};
        end else begin
            // Negative result: two's complement of magnitude
            c = {1'b1, (~res_mag + 1'b1)};
        end
    end

endmodule