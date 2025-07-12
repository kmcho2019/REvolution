// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 16-bit CLA block
module cla_16bit(a, b, cin, s, cout);
    input [16:1] a, b;
    input cin;
    output [16:1] s;
    output cout;
    wire [16:1] g, p;
    wire [15:0] c;

    // Calculate generate and propagate signals
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign c[0] = cin;
    full_adder fa1(a[1], b[1], cin, s[1], c[0]);

    generate
        for (genvar i = 2; i <= 16; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            full_adder fa(a[i], b[i], c[i-2], s[i], c[i-1]);
        end
    endgenerate

    // Carry-lookahead logic
    assign cout = g[16] | (p[16] & c[14]);

endmodule

// 32-bit CLA adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;
    wire c16;

    cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], c16);
    cla_16bit cla2(A[32:17], B[32:17], c16, S[32:17], C32);

endmodule