module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Interpret inputs as signed 8-bit values
    wire signed [7:0] a_s = a;
    wire signed [7:0] b_s = b;

    // Propagate and generate signals for carry-lookahead adder
    wire [7:0] p = a ^ b; // propagate
    wire [7:0] g = a & b; // generate

    wire [8:0] c;  // carries, c[0] = 0
    assign c[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Sum bits
    generate
        for (i = 0; i < 8; i = i +1) begin : sum_gen
            assign s[i] = p[i] ^ c[i];
        end
    endgenerate

    // Overflow detection using signed addition overflow condition:
    // Overflow = (~(a_s[7] ^ b_s[7])) & (a_s[7] ^ s[7])
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule