module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed numbers
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Overflow occurs if operands have same sign but result has different sign
    wire overflow = (a[N-1] == b[N-1]) && (sum[N-1] != a[N-1]);
    
    // Saturation values
    wire [N-1:0] max_pos = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] max_neg = {1'b1, {(N-1){1'b0}}};
    
    // Select result or saturated value
    assign c = overflow ? (a[N-1] ? max_neg : max_pos) : sum;

endmodule