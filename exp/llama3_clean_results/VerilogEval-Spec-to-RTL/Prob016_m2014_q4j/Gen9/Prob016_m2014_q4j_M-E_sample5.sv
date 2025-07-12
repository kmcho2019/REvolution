// 1-bit adder module
module BitAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// AdderNode module
module AdderNode(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    BitAdder ba(a, b, cin, sum, cout);
endmodule

// Parallelized Adder Tree (PAT) module
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire [2:0] carry;
    
    AdderNode an0(x[0], y[0], 1'b0, sum[0], carry[0]);
    AdderNode an1(x[1], y[1], carry[0], sum[1], carry[1]);
    AdderNode an2(x[2], y[2], carry[1], sum[2], carry[2]);
    AdderNode an3(x[3], y[3], carry[2], sum[3], sum[4]);
endmodule