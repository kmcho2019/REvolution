module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c           // Fixed-point output result
);

    // Define signed versions of inputs with sign extension
    wire signed [N:0] a_ext = {a[N-1], a}; // sign-extend by 1 bit
    wire signed [N:0] b_ext = {b[N-1], b}; // sign-extend by 1 bit

    // Add extended operands
    wire signed [N:0] sum_ext = a_ext + b_ext;

    // Truncate sum back to N bits by removing extra sign bit
    assign c = sum_ext[N-1:0];

endmodule