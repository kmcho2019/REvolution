module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (not used in logic, for clarity)
    parameter integer N = 16          // Total number of bits including sign and fractional parts
)(
    input  wire [N-1:0] a,            // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,            // Fixed-point operand b (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal wires for sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute value of N-bit two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)        // positive
                abs_val = val;
            else                        // negative: two's complement negation
                abs_val = (~val) + 1'b1;
        end
    endfunction

    // Combinational wires for absolute values
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Wires for sum and difference of absolute values
    wire [N-1:0] sum_abs = abs_a + abs_b;
    wire [N-1:0] diff_abs;
    wire       a_ge_b = (abs_a >= abs_b);

    // Compute difference depending on which absolute value is greater
    assign diff_abs = a_ge_b ? (abs_a - abs_b) : (abs_b - abs_a);

    // Intermediate signals for result sign and magnitude
    reg sign_res;
    reg [N-1:0] mag_res;

    // Combinational logic block
    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            mag_res = sum_abs;
            sign_res = sign_a;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            mag_res = diff_abs;
            // Sign matches the operand with the larger absolute value
            sign_res = a_ge_b ? sign_a : sign_b;

            // If result magnitude is zero, set sign to positive zero
            if (mag_res == 0)
                sign_res = 1'b0;
        end

        // Convert magnitude and sign back to two's complement representation
        if (sign_res == 1'b0) begin
            // Positive result, magnitude unchanged
            c <= mag_res;
        end else begin
            // Negative result, convert magnitude to two's complement negative
            c <= (~mag_res) + 1'b1;
        end
    end

endmodule