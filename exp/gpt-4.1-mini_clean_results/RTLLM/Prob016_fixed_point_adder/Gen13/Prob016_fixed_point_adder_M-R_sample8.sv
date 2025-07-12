module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (precision)
)(
    input  wire signed [N-1:0] a,   // Fixed-point input operand a (two's complement signed)
    input  wire signed [N-1:0] b,   // Fixed-point input operand b (two's complement signed)
    output wire signed [N-1:0] c    // Fixed-point output result
);

    // Internal register to store result
    reg signed [N-1:0] res;

    // Intermediate sum with one extra bit for overflow detection
    wire signed [N:0] sum_ext;

    // Perform addition directly on signed inputs
    assign sum_ext = a + b;

    // Assign lower N bits to res with wrap-around (discard carry/overflow)
    always @* begin
        res = sum_ext[N-1:0];
    end

    // Output the result
    assign c = res;

endmodule