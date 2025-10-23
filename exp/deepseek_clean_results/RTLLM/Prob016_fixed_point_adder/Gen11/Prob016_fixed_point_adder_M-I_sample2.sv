module fixed_point_adder #(
    parameter Q = 8,       // Number of fractional bits (must be < N)
    parameter N = 16       // Total number of bits (integer + fractional)
) (
    input wire [N-1:0] a,  // First fixed-point operand
    input wire [N-1:0] b,  // Second fixed-point operand
    output wire [N-1:0] c, // Fixed-point result
    output wire overflow   // Overflow indicator (optional)
);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Error: Q (%0d) must be less than N (%0d)", Q, N);
            $finish;
        end
    end

    // Internal signed representation
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition (automatically handles sign extension)
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Assign result (truncate to N bits)
    assign c = sum[N-1:0];
    
    // Overflow detection:
    // Overflow occurs when adding two positives gives negative,
    // or adding two negatives gives positive
    assign overflow = (a_signed[N-1] == b_signed[N-1]) && 
                     (sum[N-1] != a_signed[N-1]);

endmodule