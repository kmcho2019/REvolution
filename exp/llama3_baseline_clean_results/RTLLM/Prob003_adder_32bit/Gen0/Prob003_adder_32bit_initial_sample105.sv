// Define a module for a 1-bit full adder
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    wire p, g;

    assign p = a ^ b;
    assign g = a & b;
    assign sum = p ^ cin;
    assign cout = g | (p & cin);
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, sum, cout);
    input [15:1] a, b;
    input cin;
    output [15:1] sum;
    output cout;
    wire [15:1] p, g, c;

    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign c[1] = cin;
    assign sum[1] = p[1] ^ c[1];

    genvar i;
    generate
        for (i = 2; i <= 15; i++) begin
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign cout = g[15] | (p[15] & c[15]);
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;
    wire c16;

    cla_16bit u1(A[16:1], B[16:1], 1'b0, S[16:1], c16);
    cla_16bit u2(A[32:17], B[32:17], c16, S[32:17], C32);
endmodule