module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder (always active)
    wire [3:0] sum_low;
    wire carry_mid;
    
    // Upper 4-bit adders (compute both carry possibilities)
    wire [3:0] sum_high_0;  // Assuming carry_mid = 0
    wire [3:0] sum_high_1;  // Assuming carry_mid = 1
    wire carry_out_0, carry_out_1;
    
    // Lower nibble addition (4-bit ripple carry)
    assign {carry_mid, sum_low} = a[3:0] + b[3:0] + cin;
    
    // Upper nibble additions (parallel computation)
    assign {carry_out_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    assign {carry_out_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Carry-select muxing
    assign sum[7:4] = carry_mid ? sum_high_1 : sum_high_0;
    assign sum[3:0] = sum_low;
    assign cout = carry_mid ? carry_out_1 : carry_out_0;

endmodule