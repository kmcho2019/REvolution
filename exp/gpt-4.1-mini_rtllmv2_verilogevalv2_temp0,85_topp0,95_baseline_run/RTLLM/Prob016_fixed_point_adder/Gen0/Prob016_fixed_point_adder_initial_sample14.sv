module fixed_point_adder #(
    parameter Q = 8,           // Number of fractional bits
    parameter N = 16           // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal registers
    reg [N-1:0] res;

    // Helper function to get absolute value of two's complement N-bit number
    function [N-1:0] abs_val;
        input [N-1:0] in;
        begin
            if (in[N-1] == 1'b1)  // negative number
                abs_val = (~in) + 1'b1;
            else
                abs_val = in;
        end
    endfunction

    // Helper function to compare absolute values (returns 1 if abs(a) >= abs(b))
    function abs_ge;
        input [N-1:0] a_in;
        input [N-1:0] b_in;
        reg [N-1:0] abs_a;
        reg [N-1:0] abs_b;
        begin
            abs_a = abs_val(a_in);
            abs_b = abs_val(b_in);
            abs_ge = (abs_a >= abs_b);
        end
    endfunction

    // Combinational always block for fixed-point addition logic
    always @(*) begin
        // Extract sign bits
        wire a_sign = a[N-1];
        wire b_sign = b[N-1];

        // Compute absolute values
        wire [N-1:0] abs_a = abs_val(a);
        wire [N-1:0] abs_b = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            reg [N:0] sum_ext; // one bit wider for carry
            sum_ext = {1'b0, abs_a} + {1'b0, abs_b};

            // Assign sign bit same as inputs
            // Handle possible overflow by truncating sum_ext to N bits
            // If overflow bit (sum_ext[N]) is set, it will wrap around naturally in two's complement
            if (sum_ext[N] == 1'b0) begin
                // no overflow, normal assignment
                res = {a_sign, sum_ext[N-2:0]};
            end else begin
                // overflow bit set, take lower N bits and sign bit a_sign
                res = {a_sign, sum_ext[N-2:0]};
            end
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_ge(a, b)) begin
                // abs(a) >= abs(b)
                reg [N-1:0] diff;
                diff = abs_a - abs_b;

                // If diff is zero, sign bit = 0 (positive zero)
                if (diff == 0) begin
                    res = {1'b0, diff[N-2:0]};
                end else begin
                    // sign bit = sign of a (the operand with larger abs)
                    res = {a_sign, diff[N-2:0]};
                end
            end else begin
                // abs(b) > abs(a)
                reg [N-1:0] diff;
                diff = abs_b - abs_a;

                // If diff is zero, sign bit = 0 (positive zero)
                if (diff == 0) begin
                    res = {1'b0, diff[N-2:0]};
                end else begin
                    // sign bit = sign of b (the operand with larger abs)
                    res = {b_sign, diff[N-2:0]};
                end
            end
        end
    end

    // Output assignment
    assign c = res;

endmodule