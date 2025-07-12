module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower nibble (bits 3:0) - ripple carry
    wire [3:0] sum_low;
    wire carry_low;
    
    // Upper nibble conditional sums (for carry_in 0 and 1)
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Lower nibble adder (4-bit ripple carry)
    assign {carry_low, sum_low[0]} = a[0] + b[0] + cin;
    assign {sum_low[3:1], carry_temp} = a[3:1] + b[3:1] + {2'b0, carry_low};
    
    // Upper nibble adders (compute both possibilities)
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Final output selection
    assign sum = {carry_low ? sum_high_1 : sum_high_0, sum_low};
    assign cout = carry_low ? carry_high_1 : carry_high_0;

endmodule