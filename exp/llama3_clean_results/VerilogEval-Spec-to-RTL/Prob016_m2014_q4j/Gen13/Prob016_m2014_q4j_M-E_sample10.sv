// FullAdder module for a single bit addition
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 2-bit adder module using two FullAdders
module TwoBitAdder(a, b, sum);
    input [1:0] a;
    input [1:0] b;
    output [2:0] sum;
    
    wire c1;
    
    FullAdder fa0(a[0], b[0], 1'b0, sum[0], c1);
    FullAdder fa1(a[1], b[1], c1, sum[1], sum[2]);
endmodule

// 3-bit adder module using three FullAdders
module ThreeBitAdder(a, b, sum);
    input [2:0] a;
    input [2:0] b;
    output [3:0] sum;
    
    wire c1, c2;
    
    FullAdder fa0(a[0], b[0], 1'b0, sum[0], c1);
    FullAdder fa1(a[1], b[1], c1, sum[1], c2);
    FullAdder fa2(a[2], b[2], c2, sum[2], sum[3]);
endmodule

// TopModule using two levels of adders
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [2:0] sum_low;
    wire [2:0] sum_high;
    wire carry_low, carry_high;
    
    TwoBitAdder adder_low(x[1:0], y[1:0], sum_low);
    TwoBitAdder adder_high(x[3:2], y[3:2], sum_high);
    
    // Since we're only using 2-bit adders, we need to manually handle the carry
    assign carry_low = sum_low[2];
    assign carry_high = sum_high[2];
    
    // Now, add the sums and the carries
    wire [3:0] final_sum;
    ThreeBitAdder adder_final({1'b0, sum_low[1:0]}, {carry_low, sum_high[1:0]}, final_sum);
    
    // Finally, construct the output
    assign sum = {final_sum[3], final_sum[2:0]};
endmodule