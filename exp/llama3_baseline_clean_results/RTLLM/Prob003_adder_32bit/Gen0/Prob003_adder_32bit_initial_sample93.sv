// Define a module for a 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [16:1] a, b;
    input cin;
    output [16:1] s;
    output cout;

    wire [15:0] g, p, c;

    // Calculate the generate (g) and propagate (p) signals
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign g[i-1] = a[i] & b[i];
            assign p[i-1] = a[i] | b[i];
        end
    endgenerate

    // Calculate the carry (c) signals
    assign c[0] = cin;
    generate
        for (i = 1; i <= 15; i++) begin
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Calculate the sum (s) signals
    generate
        for (i = 1; i <= 16; i++) begin
            full_adder fa(a[i], b[i], c[i-1], s[i], cout);
        end
    endgenerate

    // The cout of the cla_16bit module is the carry-out of the 16th bit
    assign cout = c[15];
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire C16;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_lower(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit cla_upper(A[32:17], B[32:17], C16, S[32:17], C32);
endmodule