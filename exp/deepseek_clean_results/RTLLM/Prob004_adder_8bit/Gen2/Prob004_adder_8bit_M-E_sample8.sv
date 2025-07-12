module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder (computes sum for both carry scenarios)
    wire [3:0] sum_low_0, sum_low_1;
    wire carry_low_0, carry_low_1;
    
    // Case when carry-in to lower bits is 0
    assign {carry_low_0, sum_low_0} = a[3:0] + b[3:0] + 1'b0;
    
    // Case when carry-in to lower bits is 1
    assign {carry_low_1, sum_low_1} = a[3:0] + b[3:0] + 1'b1;
    
    // Upper 4-bit ripple-carry adders (computes sum for both carry scenarios)
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Case when carry-in to upper bits is 0
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    
    // Case when carry-in to upper bits is 1
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Select correct sums based on actual carry-in
    wire [3:0] final_sum_low;
    wire carry_mid;
    
    assign final_sum_low = cin ? sum_low_1 : sum_low_0;
    assign carry_mid = cin ? carry_low_1 : carry_low_0;
    
    // Select correct upper sum based on carry from lower bits
    assign sum[3:0] = final_sum_low;
    assign sum[7:4] = carry_mid ? sum_high_1 : sum_high_0;
    assign cout = carry_mid ? carry_high_1 : carry_high_0;

endmodule