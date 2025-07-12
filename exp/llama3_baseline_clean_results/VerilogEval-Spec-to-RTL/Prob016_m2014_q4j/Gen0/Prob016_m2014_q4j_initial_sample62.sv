// Define a full adder module
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the top-level module
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [3:0] cout;
    
    // Use four full adders to perform the addition
    FullAdder fa0(x[0], y[0], 1'b0, sum[0], cout[0]);
    FullAdder fa1(x[1], y[1], cout[0], sum[1], cout[1]);
    FullAdder fa2(x[2], y[2], cout[1], sum[2], cout[2]);
    FullAdder fa3(x[3], y[3], cout[2], sum[3], cout[3]);
    
    // The final carry bit is the overflow bit
    assign sum[4] = cout[3];
endmodule