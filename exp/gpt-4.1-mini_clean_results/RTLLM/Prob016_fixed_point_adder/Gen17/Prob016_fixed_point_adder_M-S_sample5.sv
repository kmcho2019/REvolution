module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (not directly used here)
    parameter integer N = 16    // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,      // Fixed-point operand A (two's complement)
    input  wire [N-1:0] b,      // Fixed-point operand B (two's complement)
    output reg  [N-1:0] c       // Fixed-point addition result (two's complement)
);

    // Internal signals for sign and magnitude
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute values: if negative, invert + 1; else as is
    wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

    // Sum and difference with an extra bit for overflow detection
    wire [N:0] sum_abs = abs_a + abs_b;
    wire [N:0] diff_abs;
    wire abs_a_ge_abs_b = (abs_a >= abs_b);

    // Calculate difference depending on which is larger
    assign diff_abs = abs_a_ge_abs_b ? (abs_a - abs_b) : (abs_b - abs_a);

    // Constants for saturation
    localparam [N-1:0] MAX_POS = {1'b0, {(N-1){1'b1}}};  // Max positive number
    localparam [N-1:0] MAX_NEG = {1'b1, {(N-1){1'b0}}};  // Min negative number (most negative)

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            if (sum_abs[N] == 1'b1) begin
                // Overflow saturation
                c = sign_a ? MAX_NEG : MAX_POS;
            end else begin
                // No overflow, compose result
                c = {sign_a, sum_abs[N-1:0]};
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (diff_abs == 0) begin
                // Result is zero, positive zero
                c = {1'b0, {(N-1){1'b0}}};
            end else if (abs_a_ge_abs_b) begin
                // a magnitude larger
                c = sign_a ? (~diff_abs[N-1:0] + 1) : diff_abs[N-1:0];
            end else begin
                // b magnitude larger
                c = sign_b ? (~diff_abs[N-1:0] + 1) : diff_abs[N-1:0];
            end
        end
    end

endmodule