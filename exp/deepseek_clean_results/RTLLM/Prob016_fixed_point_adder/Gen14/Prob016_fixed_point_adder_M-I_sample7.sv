module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals for signed interpretation
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] abs_a = a_signed[N-1] ? -a_signed : a_signed;
    wire signed [N-1:0] abs_b = b_signed[N-1] ? -b_signed : b_signed;
    
    // Determine operation based on signs
    wire same_sign = (a[N-1] == b[N-1]);
    wire a_larger = (abs_a > abs_b);
    
    // Calculate result
    wire signed [N-1:0] sum;
    assign sum = same_sign ? (a_signed + b_signed) : 
                (a_larger ? (a_signed[N-1] ? (b_signed - abs_a) : (a_signed - abs_b)) :
                (b_signed[N-1] ? (a_signed - abs_b) : (b_signed - abs_a));
    
    // Handle output with proper sign
    assign c = sum;

endmodule