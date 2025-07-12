module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    // Using the same logic but ensuring consistency in style and minimizing unnecessary operations
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a | b));
endmodule

module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [2:0] carry;
    
    // Initializing the first carry to 0, ensuring clarity
    FullAdder fa0(x[0], y[0], 1'b0, sum[0], carry[0]);
    FullAdder fa1(x[1], y[1], carry[0], sum[1], carry[1]);
    FullAdder fa2(x[2], y[2], carry[1], sum[2], carry[2]);
    // Directly assigning the final carry to sum[4] for clarity and efficiency
    FullAdder fa3(x[3], y[3], carry[2], sum[3], sum[4]);
endmodule