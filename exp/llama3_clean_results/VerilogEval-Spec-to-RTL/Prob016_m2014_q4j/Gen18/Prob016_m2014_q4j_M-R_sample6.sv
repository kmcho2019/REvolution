// FullAdder module with simplified logic
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    // Simplified logic for sum and carry-out using XOR and AND
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// TopModule using the FullAdder module in a chain
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // Instantiate FullAdder modules
    wire c1, c2, c3;
    FullAdder fa0(x[0], y[0], 1'b0, sum[0], c1);
    FullAdder fa1(x[1], y[1], c1, sum[1], c2);
    FullAdder fa2(x[2], y[2], c2, sum[2], c3);
    FullAdder fa3(x[3], y[3], c3, sum[3], sum[4]);
endmodule