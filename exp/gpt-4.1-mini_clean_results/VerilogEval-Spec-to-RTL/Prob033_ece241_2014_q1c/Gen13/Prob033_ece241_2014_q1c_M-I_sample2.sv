module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output p,       // propagate = a ^ b
    output g        // generate  = a & b
);
    assign p = a ^ b;
    assign g = a & b;
    assign sum = p ^ cin;
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;       // propagate and generate from each bit
    wire [8:0] c;          // carry signals, c[0] = 0 initial carry-in

    assign c[0] = 1'b0;    // initial carry-in is zero

    // Instantiate full adders to produce sum and propagate/generate signals
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adders
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(s[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Full 8-bit carry-lookahead logic:
    // Precompute carry signals using CLA logic formulas
    // Carry equation: c[i+1] = g[i] + p[i] & c[i]
    // Expand to express all c[i] as function of c[0] (=0) and p,g:

    // c[1] = g[0] + p[0]*c[0]
    assign c[1] = g[0] | (p[0] & c[0]);

    // c[2] = g[1] + p[1]*c[1]
    //      = g[1] + p[1]*g[0] + p[1]*p[0]*c[0]
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);

    // c[3]
    // = g[2] + p[2]*c[2]
    // = g[2] + p[2]*g[1] + p[2]*p[1]*g[0] + p[2]*p[1]*p[0]*c[0]
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

    // c[4]
    assign c[4] = g[3]
                | (p[3] & g[2])
                | (p[3] & p[2] & g[1])
                | (p[3] & p[2] & p[1] & g[0])
                | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // c[5]
    assign c[5] = g[4]
                | (p[4] & g[3])
                | (p[4] & p[3] & g[2])
                | (p[4] & p[3] & p[2] & g[1])
                | (p[4] & p[3] & p[2] & p[1] & g[0])
                | (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    // c[6]
    assign c[6] = g[5]
                | (p[5] & g[4])
                | (p[5] & p[4] & g[3])
                | (p[5] & p[4] & p[3] & g[2])
                | (p[5] & p[4] & p[3] & p[2] & g[1])
                | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    // c[7]
    assign c[7] = g[6]
                | (p[6] & g[5])
                | (p[6] & p[5] & g[4])
                | (p[6] & p[5] & p[4] & g[3])
                | (p[6] & p[5] & p[4] & p[3] & g[2])
                | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
                | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    // c[8] (carry out)
    assign c[8] = g[7]
                | (p[7] & g[6])
                | (p[7] & p[6] & g[5])
                | (p[7] & p[6] & p[5] & g[4])
                | (p[7] & p[6] & p[5] & p[4] & g[3])
                | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2])
                | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
                | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    // Overflow detection: XOR of carry-in and carry-out of MSB bit (bit 7)
    assign overflow = c[7] ^ c[8];

endmodule