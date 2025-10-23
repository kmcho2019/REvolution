`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign bit)
    parameter integer Q = 8    // Fractional bits count
)(
    input  wire signed [N-1:0] a,   // Input a in two's complement fixed-point
    input  wire signed [N-1:0] b,   // Input b in two's complement fixed-point
    output wire signed [N-1:0] c    // Output c = a - b in two's complement fixed-point
);

    // Extract sign bits (MSB) of inputs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to convert two's complement signed value to magnitude (N-1 bits)
    function [N-2:0] twos_comp_to_mag;
        input signed [N-1:0] val;
        reg [N-2:0] mag;
        begin
            if (val[N-1] == 1'b0) begin
                // positive number, magnitude is lower bits
                mag = val[N-2:0];
            end else begin
                // negative number, magnitude is two's complement of lower bits
                mag = (~val[N-2:0]) + 1'b1;
            end
            twos_comp_to_mag = mag;
        end
    endfunction

    // Compute magnitudes of inputs
    wire [N-2:0] a_mag = twos_comp_to_mag(a);
    wire [N-2:0] b_mag = twos_comp_to_mag(b);

    // Intermediate signals for result magnitude and sign
    reg res_sign;
    reg [N-2:0] res_mag;

    // Combinational block for sign and magnitude arithmetic
    // This procedural block only updates internal registers for synthesis compatibility
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: magnitude subtraction
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                res_mag = b_mag - a_mag;
                // Result sign flips because subtraction reverses order
                res_sign = ~a_sign;
            end
        end else begin
            // Different signs: magnitude addition
            res_mag = a_mag + b_mag;
            // Sign of result is sign of input with larger magnitude
            if (a_mag > b_mag) begin
                res_sign = a_sign;
            end else if (b_mag > a_mag) begin
                res_sign = b_sign;
            end else begin
                // Equal magnitude means zero result
                res_sign = 1'b0;
                res_mag = { (N-1){1'b0} };
            end
        end

        // Enforce sign bit = 0 when magnitude is zero to handle zero sign explicitly
        if (res_mag == { (N-1){1'b0} }) begin
            res_sign = 1'b0;
        end
    end

    // Internal register to store result as required
    reg signed [N-1:0] res;

    // Convert sign-magnitude result back to two's complement in continuous assignment
    // Using res_sign and res_mag computed combinationally
    always @(*) begin
        if (res_sign == 1'b0) begin
            // Positive result: MSB=0, magnitude as is
            res = {1'b0, res_mag};
        end else begin
            // Negative result: two's complement of magnitude
            res = {1'b1, (~res_mag + 1'b1)};
        end
    end

    // Assign output directly from internal register res
    assign c = res;

endmodule