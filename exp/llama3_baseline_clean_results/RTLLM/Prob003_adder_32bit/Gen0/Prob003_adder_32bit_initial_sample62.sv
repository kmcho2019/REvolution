// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:1] a, b;
    input cin;
    output [15:1] s;
    output cout;
    wire [15:1] p, g;
    wire [15:1] c;

    // Calculate generate (g) and propagate (p) signals
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign c[1] = g[1] | (p[1] & cin);

    assign s[1] = a[1] ^ b[1] ^ cin;

    genvar i;
    generate
        for (i = 2; i <= 15; i = i + 1) begin
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
            assign c[i] = g[i] | (p[i] & c[i-1]);

            assign s[i] = a[i] ^ b[i] ^ c[i-1];
        end
    endgenerate

    assign cout = g[15] | (p[15] & c[14]);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(a, b, s, c32);
    input [32:1] a, b;
    output [32:1] s;
    output c32;
    wire c16;

    // 16-bit CLA for least significant bits
    cla_16bit cla_ls(a[16:1], b[16:1], 1'b0, s[16:1], c16);

    // 16-bit CLA for most significant bits
    cla_16bit cla_ms(a[32:17], b[32:17], c16, s[32:17], c32);
endmodule