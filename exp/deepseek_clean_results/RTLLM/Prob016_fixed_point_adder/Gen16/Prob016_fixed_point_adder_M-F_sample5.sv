module fixed_point_adder #(
    parameter N = 16   // Total bits (including sign)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Determine operation type (same sign = addition)
    wire op_add = (a[N-1] == b[N-1]);
    
    // Perform the arithmetic operation
    wire signed [N-1:0] sum = a_signed + b_signed;
    wire signed [N-1:0] diff = a_signed - b_signed;
    
    // Detect overflow (only possible in addition case)
    wire overflow = op_add & (sum[N-1] != a[N-1]);
    
    // Select result based on operation
    wire signed [N-1:0] res = op_add ? sum : diff;
    
    // Apply saturation if overflow occurred
    assign c = overflow ? 
               {a[N-1], {N-1{~a[N-1]}}} :  // Saturate to max/min
               res;

endmodule