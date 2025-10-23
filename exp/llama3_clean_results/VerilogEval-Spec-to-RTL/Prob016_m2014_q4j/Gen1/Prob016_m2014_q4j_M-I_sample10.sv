// Full Adder module (optimized for area and power)
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    // Optimized full adder implementation using fewer gates
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// TopModule with carry-lookahead adder architecture
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    wire p, g, c1, c2, c3, c4;
    
    // Calculate propagate and generate signals
    assign p[0] = x[0] ^ y[0];
    assign g[0] = x[0] & y[0];
    assign p[1] = x[1] ^ y[1];
    assign g[1] = x[1] & y[1];
    assign p[2] = x[2] ^ y[2];
    assign g[2] = x[2] & y[2];
    assign p[3] = x[3] ^ y[3];
    assign g[3] = x[3] & y[3];
    
    // Calculate carry signals using carry-lookahead architecture
    assign c1 = g[0] | (p[0] & 1'b0); // initial carry is 0
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c4 = g[3] | (p[3] & c3);
    
    // Calculate sum signals
    assign sum[0] = p[0] ^ 1'b0; // initial carry is 0
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = c4; // overflow bit
endmodule