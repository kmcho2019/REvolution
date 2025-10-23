module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (precision)
    parameter integer N = 16    // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,      // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,      // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c       // Fixed-point addition result (two's complement)
);

    // Cast inputs to signed for arithmetic operations
    wire signed [N-1:0] signed_a = a;
    wire signed [N-1:0] signed_b = b;

    // Extended addition to detect overflow
    wire signed [N:0] sum_ext = signed_a + signed_b;

    // Saturation boundaries for N-bit two's complement
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};  // max positive number (e.g., 011...1)
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};  // min negative number (e.g., 100...0)

    // Saturate sum if it exceeds bounds
    assign c = (sum_ext > MAX_VAL) ? MAX_VAL :
               (sum_ext < MIN_VAL) ? MIN_VAL :
               sum_ext[N-1:0];

endmodule