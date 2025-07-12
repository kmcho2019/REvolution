module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits (precision)
    parameter integer N = 16     // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,       // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c        // Fixed-point addition result (two's complement)
);

    // Signed versions of inputs and intermediate sum for proper arithmetic
    wire signed [N-1:0] signed_a = a;
    wire signed [N-1:0] signed_b = b;

    // Intermediate sum with extra bit to detect overflow
    reg signed [N:0] sum_ext;

    // Saturation limits
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}}; // max positive: 0 followed by all ones
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}}; // min negative: 1 followed by all zeros

    always @(*) begin
        // Perform addition with extended width
        sum_ext = signed_a + signed_b;

        // Check for overflow and saturate accordingly
        if (sum_ext > MAX_VAL) begin
            c <= MAX_VAL;
        end else if (sum_ext < MIN_VAL) begin
            c <= MIN_VAL;
        end else begin
            c <= sum_ext[N-1:0];
        end
    end

endmodule