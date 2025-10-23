module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Lower 4-bit adder (always used)
    wire [3:0] sum_low;
    wire carry_low;
    
    // Upper 4-bit adders (parallel computation)
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Lower 4-bit ripple-carry adder
    assign {carry_low, sum_low} = a[3:0] + b[3:0] + cin;
    
    // Upper 4-bit adders (both carry assumptions)
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Output selection muxes
    assign sum[3:0] = sum_low;
    assign sum[7:4] = carry_low ? sum_high_1 : sum_high_0;
    assign cout = carry_low ? carry_high_1 : carry_high_0;
    
endmodule