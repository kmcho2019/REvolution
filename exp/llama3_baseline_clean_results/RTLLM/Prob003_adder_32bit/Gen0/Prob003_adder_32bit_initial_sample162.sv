// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    wire [2:0] g, p, c;
    
    // Compute generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] | b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] | b[3];
    
    // Compute carry signals
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign cout = g[3] | (p[3] & c[3]);
    
    // Compute sum signals
    assign s[0] = a[0] ^ b[0] ^ c[0];
    assign s[1] = a[1] ^ b[1] ^ c[1];
    assign s[2] = a[2] ^ b[2] ^ c[2];
    assign s[3] = a[3] ^ b[3] ^ c[3];
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire c4, c8, c12;
    
    cla_4bit cla0(a[3:0], b[3:0], cin, s[3:0], c4);
    cla_4bit cla1(a[7:4], b[7:4], c4, s[7:4], c8);
    cla_4bit cla2(a[11:8], b[11:8], c8, s[11:8], c12);
    cla_4bit cla3(a[15:12], b[15:12], c12, s[15:12], cout);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(a, b, s, c32);
    input [31:1] a, b;
    output [31:1] s;
    output c32;
    wire c16;
    
    cla_16bit cla0(a[15:1], b[15:1], 1'b0, s[15:1], c16);
    cla_16bit cla1(a[31:16], b[31:16], c16, s[31:16], c32);
endmodule