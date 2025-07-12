// 1-bit full adder module
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 16-bit carry-lookahead adder module
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire [15:0] g, p;
    wire [15:1] c;

    // Calculate generate (g) and propagate (p) signals
    genvar i;
    generate
        for (i = 0; i <= 15; i++) begin
            if (i == 0) begin
                assign g[i] = a[i] & b[i];
                assign p[i] = a[i] ^ b[i];
                full_adder fa0(a[i], b[i], cin, s[i], c[i]);
            end else begin
                assign g[i] = a[i] & b[i];
                assign p[i] = a[i] ^ b[i];
                full_adder fa(a[i], b[i], c[i-1], s[i], c[i]);
            end
        end
    endgenerate

    // Calculate carry-out
    assign cout = g[15] | (p[15] & c[14]);
endmodule

// 32-bit carry-lookahead adder module
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    wire C16;

    // Instance of 16-bit CLA for lower 16 bits
    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], C16);

    // Instance of 16-bit CLA for upper 16 bits
    cla_16bit cla1(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule