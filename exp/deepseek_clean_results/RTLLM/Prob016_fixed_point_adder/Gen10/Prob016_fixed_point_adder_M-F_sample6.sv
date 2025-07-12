module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits (default 8)
    parameter N = 16  // Total bits (default 16)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q (fractional bits) must be less than N (total bits)");
        if (N < 2) $error("N (total bits) must be at least 2");
    end

    // Explicit signed conversion with proper width
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);
    
    // Perform signed addition (automatically handles subtraction via two's complement)
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Assign output with explicit width control
    assign c = sum[N-1:0];

    /* Optional overflow detection
    wire overflow = (a_signed[N-1] == b_signed[N-1]) && 
                   (sum[N-1] != a_signed[N-1]);
    */

endmodule