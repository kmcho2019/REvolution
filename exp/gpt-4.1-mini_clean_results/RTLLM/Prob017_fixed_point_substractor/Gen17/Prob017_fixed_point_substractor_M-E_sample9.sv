`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,      // Total bits (including sign)
    parameter integer Q = 8        // Fractional bits
)(
    input  wire [N-1:0] a,         // Fixed-point operand a (signed two's complement)
    input  wire [N-1:0] b,         // Fixed-point operand b (signed two's complement)
    output reg  [N-1:0] c          // Result c = a - b (signed fixed-point)
);

    // Internal registers for sign, magnitude, and result components
    reg sign_a, sign_b;
    reg [N-2:0] mag_a, mag_b;      // Magnitudes exclude sign bit (MSB)
    
    reg [N-1:0] mag_res;            // Result magnitude with an extra bit for carry/borrow
    reg sign_res;                   // Sign of the result
    
    reg [N-1:0] res_twos_complement;// Result in two's complement to assign to output

    // Temporary variables for comparisons
    reg mag_a_ge_mag_b;             // mag_a >= mag_b
    reg [N-1:0] mag_add;            // For addition (used in different sign case)
    reg [N-1:0] mag_sub;            // For subtraction (used in same sign case)
    
    // Function: two's complement negation of magnitude with N-1 bits
    function [N-2:0] twos_comp_mag;
        input [N-2:0] x;
        begin
            twos_comp_mag = (~x) + 1'b1;
        end
    endfunction

    // Convert magnitude + sign to two's complement N-bit number
    function [N-1:0] mag_sign_to_twos;
        input [N-2:0] magnitude;
        input         sign;
        begin
            if (sign)
                mag_sign_to_twos = {1'b1, twos_comp_mag(magnitude)};
            else
                mag_sign_to_twos = {1'b0, magnitude};
        end
    endfunction

    // Compute absolute magnitude of input from two's complement signed input
    function [N-2:0] abs_mag;
        input [N-1:0] in;
        reg sign_in;
        reg [N-2:0] mag_in;
        begin
            sign_in = in[N-1];
            mag_in = in[N-2:0];
            if (sign_in)
                abs_mag = twos_comp_mag(mag_in);
            else
                abs_mag = mag_in;
        end
    endfunction

    always @(*) begin
        // Extract sign and magnitude for inputs
        sign_a = a[N-1];
        sign_b = b[N-1];
        mag_a  = abs_mag(a);
        mag_b  = abs_mag(b);

        if (sign_a == sign_b) begin
            // Same sign: subtract magnitudes (mag_a - mag_b)
            if (mag_a >= mag_b) begin
                mag_sub = mag_a - mag_b;
                sign_res = sign_a; // same sign as inputs
            end else begin
                mag_sub = mag_b - mag_a;
                sign_res = ~sign_a; // opposite sign since mag_b > mag_a
            end
            mag_res = {1'b0, mag_sub}; // zero extend to N bits for result

        end else begin
            // Different signs: add magnitudes (mag_a + mag_b)
            mag_add = mag_a + mag_b;
            // Determine sign of result depends on which magnitude is greater
            mag_a_ge_mag_b = (mag_a >= mag_b);
            if (mag_a_ge_mag_b)
                sign_res = sign_a; 
            else
                sign_res = sign_b;

            mag_res = {1'b0, mag_add[N-2:0]}; // keep N bits, ignore overflow beyond N bits if any
        end

        // Special case: if result magnitude zero, sign must be cleared
        if (mag_res[N-2:0] == { (N-1){1'b0} }) begin
            sign_res = 1'b0;
        end

        // Convert result magnitude + sign to two's complement for output
        res_twos_complement = mag_sign_to_twos(mag_res[N-2:0], sign_res);

        // Assign internal result register
        res_twos_complement = res_twos_complement;

        c = res_twos_complement;
    end

endmodule