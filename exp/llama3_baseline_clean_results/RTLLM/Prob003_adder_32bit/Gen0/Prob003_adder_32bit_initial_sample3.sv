// 1-bit Full Adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(a, b, cin, s, cout);
    input [15:1] a, b;
    input cin;
    output [15:1] s;
    output cout;
    wire [15:1] g, p; // Generate and Propagate signals
    wire [15:1] c; // Internal carry signals

    // Calculate Generate (g) and Propagate (p) signals
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    for (genvar i = 2; i <= 15; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end

    // Calculate internal carry signals
    assign c[1] = cin;
    for (genvar i = 2; i <= 15; i++) begin
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end

    // Calculate sum (s) and final carry-out (cout)
    assign s[1] = a[1] ^ b[1] ^ cin;
    for (genvar i = 2; i <= 15; i++) begin
        assign s[i] = a[i] ^ b[i] ^ c[i];
    end
    assign cout = g[15] | (p[15] & c[15]);
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;
    wire c16; // Carry from first 16 bits to second 16 bits

    // First 16-bit block
    cla_16bit u1(
        .a(A[16:1]), 
        .b(B[16:1]), 
        .cin(1'b0), 
        .s(S[16:1]), 
        .cout(c16)
    );

    // Second 16-bit block
    cla_16bit u2(
        .a(A[32:17]), 
        .b(B[32:17]), 
        .cin(c16), 
        .s(S[32:17]), 
        .cout(C32)
    );
endmodule