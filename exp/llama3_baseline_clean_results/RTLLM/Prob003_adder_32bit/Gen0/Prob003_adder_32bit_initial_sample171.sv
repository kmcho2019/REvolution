// Define the 1-bit full adder module
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the 4-bit carry-lookahead adder module
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    wire [2:0] p, g;
    wire [1:0] c;

    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign c[0] = g[0] | (a[0] & cin) | (b[0] & cin);

    assign s[0] = a[0] ^ b[0] ^ cin;

    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign c[1] = g[1] | (a[1] & c[0]) | (b[1] & c[0]);

    assign s[1] = a[1] ^ b[1] ^ c[0];

    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign c[0] = g[2] | (a[2] & c[1]) | (b[2] & c[1]);

    assign s[2] = a[2] ^ b[2] ^ c[1];

    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];
    assign cout = g[3] | (a[3] & c[2]) | (b[3] & c[2]);

    assign s[3] = a[3] ^ b[3] ^ c[2];
endmodule

// Define the 16-bit carry-lookahead adder module
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire [7:0] p, g;
    wire [7:0] c;

    // First 4-bit block
    cla_4bit u1(a[3:0], b[3:0], cin, s[3:0], c[0]);
    
    // Second 4-bit block
    cla_4bit u2(a[7:4], b[7:4], c[0], s[7:4], c[1]);

    // Third 4-bit block
    cla_4bit u3(a[11:8], b[11:8], c[1], s[11:8], c[2]);

    // Fourth 4-bit block
    cla_4bit u4(a[15:12], b[15:12], c[2], s[15:12], cout);
endmodule

// Define the 32-bit carry-lookahead adder module
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    wire C16;

    // First 16-bit block
    cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], C16);

    // Second 16-bit block
    cla_16bit u2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule