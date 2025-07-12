module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits (integer + fractional)
) (
    input wire [N-1:0] a,  // First operand
    input wire [N-1:0] b,  // Second operand
    output wire [N-1:0] c  // Result
);

    // Parameter validation (commented out during synthesis)
    // synthesis translate_off
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N <= 1) $error("N must be greater than 1");
    end
    // synthesis translate_on

    // Signed arithmetic core
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Main addition operation
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Output assignment
    assign c = sum[N-1:0];

    // Optional overflow detection (uncomment if needed)
    // wire overflow = (a_signed[N-1] == b_signed[N-1]) && 
    //                (sum[N-1] != a_signed[N-1]);

endmodule