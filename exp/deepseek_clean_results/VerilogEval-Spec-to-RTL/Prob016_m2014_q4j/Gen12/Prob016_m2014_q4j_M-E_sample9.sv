module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (LSBs)
    wire c_low;
    FullAdder fa0(x[0], y[0], 1'b0, sum[0], c0);
    FullAdder fa1(x[1], y[1], c0, sum[1], c_low);
    
    // Upper 2 bits with both possible carry-in values
    wire [1:0] sum_high_c0, sum_high_c1;
    wire c_high_c0, c_high_c1;
    
    // Compute upper bits assuming carry-in = 0
    FullAdder fa2_c0(x[2], y[2], 1'b0, sum_high_c0[0], c2_c0);
    FullAdder fa3_c0(x[3], y[3], c2_c0, sum_high_c0[1], c_high_c0);
    
    // Compute upper bits assuming carry-in = 1
    FullAdder fa2_c1(x[2], y[2], 1'b1, sum_high_c1[0], c2_c1);
    FullAdder fa3_c1(x[3], y[3], c2_c1, sum_high_c1[1], c_high_c1);
    
    // Select correct upper sum based on actual carry from lower bits
    assign sum[2] = c_low ? sum_high_c1[0] : sum_high_c0[0];
    assign sum[3] = c_low ? sum_high_c1[1] : sum_high_c0[1];
    assign sum[4] = c_low ? c_high_c1 : c_high_c0;
endmodule