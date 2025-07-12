// Half Adder module
module HalfAdder(a, b, sum, carry);
    input a, b;
    output sum, carry;
    
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// Full Adder module using a more efficient logic style
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// TopModule with clock gating and alternative adder architecture
module TopModule(clk, x, y, sum);
    input clk;
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    reg [3:0] carry;
    
    always @(posedge clk) begin
        carry[0] <= 1'b0;
        sum[0] <= x[0] ^ y[0] ^ carry[0];
        carry[1] <= (x[0] & y[0]) | (x[0] & carry[0]) | (y[0] & carry[0]);
        
        sum[1] <= x[1] ^ y[1] ^ carry[1];
        carry[2] <= (x[1] & y[1]) | (x[1] & carry[1]) | (y[1] & carry[1]);
        
        sum[2] <= x[2] ^ y[2] ^ carry[2];
        carry[3] <= (x[2] & y[2]) | (x[2] & carry[2]) | (y[2] & carry[2]);
        
        sum[3] <= x[3] ^ y[3] ^ carry[3];
        sum[4] <= (x[3] & y[3]) | (x[3] & carry[3]) | (y[3] & carry[3]);
    end
endmodule