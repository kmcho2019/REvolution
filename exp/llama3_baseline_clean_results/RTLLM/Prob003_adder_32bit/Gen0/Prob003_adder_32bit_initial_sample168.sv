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
    wire p, g;
    wire [3:0] g_local, p_local;
    assign p_local[0] = a[0] ^ b[0];
    assign g_local[0] = a[0] & b[0];
    assign s[0] = p_local[0] ^ cin;
    assign cout = g_local[0] | (p_local[0] & cin);

    assign p_local[1] = a[1] ^ b[1];
    assign g_local[1] = a[1] & b[1];
    assign p = p_local[0] & p_local[1];
    assign g = g_local[1] | (g_local[0] & p_local[1]);
    assign s[1] = p_local[1] ^ cout;
    
    assign p_local[2] = a[2] ^ b[2];
    assign g_local[2] = a[2] & b[2];
    assign p = p_local[0] & p_local[1] & p_local[2];
    assign g = g_local[2] | (g_local[1] & p_local[2]) | (g_local[0] & p_local[1] & p_local[2]);
    assign s[2] = p_local[2] ^ cout;
    
    assign p_local[3] = a[3] ^ b[3];
    assign g_local[3] = a[3] & b[3];
    assign p = p_local[0] & p_local[1] & p_local[2] & p_local[3];
    assign g = g_local[3] | (g_local[2] & p_local[3]) | (g_local[1] & p_local[2] & p_local[3]) | (g_local[0] & p_local[1] & p_local[2] & p_local[3]);
    assign s[3] = p_local[3] ^ cout;
    
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire p, g;
    wire [3:0] g_local, p_local;
    cla_4bit cla_0(a[3:0], b[3:0], cin, s[3:0], g_local[0]);
    cla_4bit cla_1(a[7:4], b[7:4], g_local[0], s[7:4], g_local[1]);
    cla_4bit cla_2(a[11:8], b[11:8], g_local[1], s[11:8], g_local[2]);
    cla_4bit cla_3(a[15:12], b[15:12], g_local[2], s[15:12], cout);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:0] A, B;
    output [31:0] S;
    output C32;
    wire c16;
    cla_16bit cla_0(A[15:0], B[15:0], 1'b0, S[15:0], c16);
    cla_16bit cla_1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule