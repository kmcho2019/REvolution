module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values as unsigned (to compare magnitudes)
    wire [N-1:0] a_abs = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = sign_b ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_ge_b = (a_abs >= b_abs);

    // Sum and difference of absolute values
    wire [N-1:0] sum_abs = a_abs + b_abs;
    wire [N-1:0] diff_abs = a_ge_b ? (a_abs - b_abs) : (b_abs - a_abs);

    // Determine result sign for subtraction case
    wire res_sign_sub = a_ge_b ? sign_a : sign_b;

    always @* begin
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes, sign stays the same
            if (sign_a) begin
                // Negative sign: two's complement of sum_abs
                c = ~sum_abs + 1'b1;
            end else begin
                // Positive sign: direct sum_abs
                c = sum_abs;
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (res_sign_sub) begin
                // Negative result: two's complement of diff_abs
                c = ~diff_abs + 1'b1;
            end else begin
                // Positive result: direct diff_abs
                c = diff_abs;
            end
        end
        // No explicit zero forcing needed; zero is represented as all zeros naturally
    end

endmodule