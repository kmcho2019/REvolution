module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit adder (always computes sum for carry-in 0)
    wire [3:0] sum_low_0;
    wire [3:0] sum_low_1;
    wire cout_low_0, cout_low_1;
    
    // Compute both possible sums for lower nibble
    assign {cout_low_0, sum_low_0} = a[3:0] + b[3:0] + 1'b0;
    assign {cout_low_1, sum_low_1} = a[3:0] + b[3:0] + 1'b1;
    
    // Select correct lower sum based on actual carry-in
    wire [3:0] sum_low = cin ? sum_low_1 : sum_low_0;
    wire carry_mid = cin ? cout_low_1 : cout_low_0;
    
    // Upper 4-bit adder (computes both possible sums)
    wire [3:0] sum_high_0;
    wire [3:0] sum_high_1;
    wire cout_high_0, cout_high_1;
    
    // Compute both possible sums for upper nibble
    assign {cout_high_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    assign {cout_high_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Select correct upper sum based on mid carry
    wire [3:0] sum_high = carry_mid ? sum_high_1 : sum_high_0;
    assign cout = carry_mid ? cout_high_1 : cout_high_0;
    
    // Combine final outputs
    assign sum = {sum_high, sum_low};

endmodule