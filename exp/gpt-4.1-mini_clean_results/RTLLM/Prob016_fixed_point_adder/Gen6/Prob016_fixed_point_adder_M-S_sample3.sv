module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform two's complement addition directly
    // Treat inputs as signed fixed-point numbers
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N:0] sum_extended = a_signed + b_signed; // one extra bit for overflow

    // Output is lower N bits (overflow bit discarded)
    assign c = sum_extended[N-1:0];

endmodule