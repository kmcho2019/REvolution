// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire [15:0] g, p;
    wire [14:0] c;

    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign c[0] = g[0] | (p[0] & cin);

    genvar i;
    generate
        for (i = 1; i < 15; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    assign cout = g[15] | (p[15] & c[14]);

    assign s[0] = a[0] ^ b[0] ^ cin;
    generate
        for (i = 1; i < 16; i++) begin
            assign s[i] = a[i] ^ b[i] ^ c[i-1];
        end
    endgenerate
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16;

    cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit u2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule