module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire carry_low;
    
    assign {carry_low, sum_low} = a[3:0] + b[3:0] + cin;
    
    // Upper 4-bit carry-select logic
    wire [3:0] sum_high_c0, sum_high_c1;
    wire carry_high_c0, carry_high_c1;
    
    // Compute upper sum assuming carry_in = 0
    assign {carry_high_c0, sum_high_c0} = a[7:4] + b[7:4];
    
    // Compute upper sum assuming carry_in = 1
    assign {carry_high_c1, sum_high_c1} = a[7:4] + b[7:4] + 1;
    
    // Select correct upper sum based on actual carry from lower bits
    assign sum[7:4] = carry_low ? sum_high_c1 : sum_high_c0;
    assign cout = carry_low ? carry_high_c1 : carry_high_c0;
    
    // Lower sum is always the same
    assign sum[3:0] = sum_low;

endmodule