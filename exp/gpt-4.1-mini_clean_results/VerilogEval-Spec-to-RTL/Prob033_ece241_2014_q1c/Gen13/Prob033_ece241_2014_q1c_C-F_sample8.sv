module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output p,   // propagate = a ^ b
    output g    // generate = a & b
);
    assign p = a ^ b;
    assign g = a & b;
    assign sum = p ^ cin;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;
    wire [8:0] c;

    // Group propagate and generate for two 4-bit halves
    wire pg0, gg0; // lower nibble group
    wire pg1, gg1; // upper nibble group

    assign c[0] = 1'b0; // initial carry-in

    genvar i;
    generate
        // Instantiate FullAdders for each bit
        for (i = 0; i < 8; i = i + 1) begin : fa_loop
            FullAdder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(s[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Compute group propagate and generate for lower 4 bits
    assign pg0 = p[3] & p[2] & p[1] & p[0];
    assign gg0 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Compute group propagate and generate for upper 4 bits
    assign pg1 = p[7] & p[6] & p[5] & p[4];
    assign gg1 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);

    // Compute carry-outs for group boundaries
    assign c[4] = gg0 | (pg0 & c[0]);       // Carry into bit 4
    assign c[8] = gg1 | (pg1 & c[4]);       // Carry out of MSB

    // Compute intermediate carries within each group using ripple carry inside groups (4 bits each)
    // Lower nibble carries c[1] to c[3]
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);

    // Upper nibble carries c[5] to c[7]
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);

    // Overflow = carry into MSB xor carry out of MSB
    assign overflow = c[7] ^ c[8];

endmodule