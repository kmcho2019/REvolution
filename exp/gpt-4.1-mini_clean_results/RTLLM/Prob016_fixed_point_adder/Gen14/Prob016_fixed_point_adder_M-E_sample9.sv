module fixed_point_adder #(
    parameter integer N = 16,    // Total bits: sign + integer + fractional
    parameter integer Q = 8      // Number of fractional bits
)(
    input  wire [N-1:0] a,       // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c        // Fixed-point output result
);

    // Internal registers for sign and magnitude
    wire a_sign;
    wire b_sign;
    wire [N-2:0] a_mag;  // Magnitude excludes sign bit
    wire [N-2:0] b_mag;

    reg        res_sign;
    reg [N-2:0] res_mag;
    reg [N-1:0] res;

    // Extract sign bit (MSB)
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];

    // Function to compute absolute magnitude from signed two's complement input
    function [N-2:0] abs_mag;
        input [N-1:0] in;
        reg   [N-1:0] inverted;
        begin
            if (in[N-1] == 1'b0)
                abs_mag = in[N-2:0];
            else begin
                inverted = ~in + 1;
                abs_mag = inverted[N-2:0];
            end
        end
    endfunction

    assign a_mag = abs_mag(a);
    assign b_mag = abs_mag(b);

    // Combinational logic for addition or subtraction
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes, sign stays the same
            {res_sign, res_mag} = {1'b0, a_mag} + {1'b0, b_mag};
            res_sign = a_sign;
            // If magnitude addition overflowed beyond N-1 bits, it wraps (no saturation)
            // res_sign is kept as a_sign
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag >= b_mag) begin
                res_mag = a_mag - b_mag;
                res_sign = a_sign; // Sign of operand with larger magnitude
            end else begin
                res_mag = b_mag - a_mag;
                res_sign = b_sign;
            end
        end

        // Handle zero result sign convention: zero magnitude => positive sign (0)
        if (res_mag == 0)
            res_sign = 1'b0;

        // Combine sign and magnitude to form two's complement output
        if (res_sign == 1'b0) begin
            // Positive result: straightforward concatenation
            res = {res_sign, res_mag};
        end else begin
            // Negative result: two's complement of magnitude
            res = (~{res_sign, res_mag}) + 1;
        end
    end

    assign c = res;

endmodule