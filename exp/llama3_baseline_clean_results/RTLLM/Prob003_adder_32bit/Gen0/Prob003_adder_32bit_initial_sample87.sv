// Define a module for a 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] s;
    output cout;
    
    wire [3:0] g, p;
    wire c1, c2, c3;
    
    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] ^ b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] ^ b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] ^ b[3];
    
    // Calculate internal carries
    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    
    // Calculate sum and final carry
    full_adder fa0(a[0], b[0], cin, s[0], );
    full_adder fa1(a[1], b[1], c1, s[1], );
    full_adder fa2(a[2], b[2], c2, s[2], );
    full_adder fa3(a[3], b[3], c3, s[3], );
    assign cout = g[3] | (p[3] & c3);
endmodule

// Define a module for a 16-bit carry-lookahead adder using 4-bit blocks
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a;
    input [15:0] b;
    input cin;
    output [15:0] s;
    output cout;
    
    wire c4, c8, c12;
    
    // Divide into four 4-bit blocks
    cla_4bit block0(a[3:0], b[3:0], cin, s[3:0], c4);
    cla_4bit block1(a[7:4], b[7:4], c4, s[7:4], c8);
    cla_4bit block2(a[11:8], b[11:8], c8, s[11:8], c12);
    cla_4bit block3(a[15:12], b[15:12], c12, s[15:12], cout);
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;
    
    wire c16;
    
    // Divide into two 16-bit blocks
    cla_16bit block0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit block1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule