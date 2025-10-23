module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Early overflow prediction
    wire overflow_possible = (A[63] ^ B[63]);
    
    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] sum;
    
    // Lower 32-bit: Conditional Sum Adder
    wire [31:0] sum0_low, sum1_low;
    wire cout0_low, cout1_low;
    
    // Compute both possible sums (carry=0 and carry=1)
    assign {cout0_low, sum0_low} = A[31:0] + B_comp[31:0] + 0;
    assign {cout1_low, sum1_low} = A[31:0] + B_comp[31:0] + 1;
    
    // Upper 32-bit: Carry-Select Adder
    wire [31:0] sum0_high, sum1_high;
    
    // Compute both possible sums for upper bits
    assign sum0_high = A[63:32] + B_comp[63:32] + 0;
    assign sum1_high = A[63:32] + B_comp[63:32] + 1;
    
    // Final carry selection
    wire carry_out = cout1_low; // Actual carry from lower bits
    wire [31:0] sum_high = carry_out ? sum1_high : sum0_high;
    wire [31:0] sum_low = carry_out ? sum1_low : sum0_low;
    
    // Combine results
    assign sum = {sum_high, sum_low};
    assign result = sum;
    
    // Final overflow detection
    assign overflow = overflow_possible & (A[63] ^ sum[63]);

endmodule