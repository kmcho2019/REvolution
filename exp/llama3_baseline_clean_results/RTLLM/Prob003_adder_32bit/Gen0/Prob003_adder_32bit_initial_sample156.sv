// Define the module for a 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;

    wire [15:0] g, p; // Generate and propagate signals
    wire [14:0] c; // Internal carry signals

    // Calculate generate (g) and propagate (p) signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    for (genvar i = 1; i < 16; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end

    // Calculate internal carry signals
    assign c[0] = cin;
    for (genvar i = 1; i < 15; i++) begin
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
    assign cout = g[15] | (p[15] & c[15]);

    // Calculate sum signals
    for (genvar i = 0; i < 16; i++) begin
        assign s[i] = a[i] ^ b[i] ^ c[i];
    end
endmodule

// Define the module for a 32-bit carry-lookahead adder using two 16-bit CLA blocks
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire c16; // Carry from lower 16 bits

    // Lower 16 bits
    cla_16bit lower_cla(
        .a(A[15:1]),
        .b(B[15:1]),
        .cin(1'b0),
        .s(S[15:1]),
        .cout(c16)
    );

    // Upper 16 bits
    cla_16bit upper_cla(
        .a(A[31:16]),
        .b(B[31:16]),
        .cin(c16),
        .s(S[31:16]),
        .cout(C32)
    );
endmodule