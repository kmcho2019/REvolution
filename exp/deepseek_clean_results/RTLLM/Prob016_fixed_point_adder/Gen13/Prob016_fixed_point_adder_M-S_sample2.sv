module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Detect overflow (when signs don't match)
    wire overflow = (a[N-1] == b[N-1]) && (sum[N-1] != a[N-1]);
    
    // Saturate result on overflow
    assign c = overflow ? 
               {a[N-1], {(N-1){~a[N-1]}}} :  // Max positive or min negative
               sum;

endmodule