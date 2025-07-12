// Define the module for a 1-bit full adder
module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;

    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (a & c_in) | (b & c_in);
endmodule

// Define the module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, c_in, s, c_out);
    input [15:1] a, b;
    input c_in;
    output [15:1] s;
    output c_out;

    wire [15:1] g, p;
    wire [14:1] c;

    // Calculate generate and propagate signals
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign c[1] = g[1] | (p[1] & c_in);

    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Calculate sum
    assign s[1] = a[1] ^ b[1] ^ c_in;
    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign s[i] = a[i] ^ b[i] ^ c[i-1];
        end
    endgenerate

    // Calculate final carry out
    assign c_out = g[15] | (p[15] & c[14]);
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire c16;

    // Lower 16 bits
    cla_16bit u1(A[16:1], B[16:1], 1'b0, S[16:1], c16);

    // Upper 16 bits
    cla_16bit u2(A[32:17], B[32:17], c16, S[32:17], C32);
endmodule