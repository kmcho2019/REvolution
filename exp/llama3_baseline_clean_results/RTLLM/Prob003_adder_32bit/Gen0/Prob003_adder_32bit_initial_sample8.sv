// Define a 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;

    wire [15:0] g, p;
    wire [14:0] c;

    // Generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign c[0] = g[0] | (p[0] & cin);

    // For each bit from 1 to 15
    genvar i;
    generate
        for (i = 1; i < 16; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] ^ b[i];
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Final sum generation
    assign s[0] = p[0] ^ cin;
    generate
        for (i = 1; i < 16; i++) begin
            assign s[i] = p[i] ^ c[i-1];
        end
    endgenerate

    assign cout = c[15];
endmodule

// Define the 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16;

    // Two instances of 16-bit CLA, one for lower 16 bits and one for upper 16 bits
    cla_16bit lower_cla(
        .a(A[16:1]), 
        .b(B[16:1]), 
        .cin(1'b0), 
        .s(S[16:1]), 
        .cout(C16)
    );

    cla_16bit upper_cla(
        .a(A[31:17]), 
        .b(B[31:17]), 
        .cin(C16), 
        .s(S[31:17]), 
        .cout(C32)
    );
endmodule