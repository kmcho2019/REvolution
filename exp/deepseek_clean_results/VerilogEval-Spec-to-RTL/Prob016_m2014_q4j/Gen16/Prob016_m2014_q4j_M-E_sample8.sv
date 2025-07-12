module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout,
    output p
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    assign p = a ^ b;  // Propagate signal
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [1:0] p;      // Block propagate signals
    wire [1:0] g;      // Block generate signals
    wire c1, c2, c3;   // Intermediate carries
    wire skip_carry;   // Skip carry for block 1
    
    // First 2-bit block (bits 0-1)
    FullAdder fa0 (x[0], y[0], 1'b0, sum[0], c1, p[0]);
    FullAdder fa1 (x[1], y[1], c1, sum[1], c2, p[1]);
    
    // Block 0 propagate and generate
    wire block0_p = p[0] & p[1];
    wire block0_g = (p[1] & g[0]) | g[1];
    
    // Second 2-bit block (bits 2-3)
    FullAdder fa2 (x[2], y[2], skip_carry, sum[2], c3, p[0]);
    FullAdder fa3 (x[3], y[3], c3, sum[3], sum[4], p[1]);
    
    // Block 1 propagate and generate
    wire block1_p = p[0] & p[1];
    wire block1_g = (p[1] & g[0]) | g[1];
    
    // Carry-skip logic
    assign skip_carry = block0_p ? c2 : block0_g;
    
    // Assign generate signals (g = a & b)
    assign g[0] = x[0] & y[0];
    assign g[1] = x[1] & y[1];
    assign g[0] = x[2] & y[2];
    assign g[1] = x[3] & y[3];
endmodule