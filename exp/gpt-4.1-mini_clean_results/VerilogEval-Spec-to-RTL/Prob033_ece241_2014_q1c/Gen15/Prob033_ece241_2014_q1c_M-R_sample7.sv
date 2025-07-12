module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals
    wire [8:0] c; // carry signals: c[0] is carry-in (0), c[8] is final carry-out

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = 1'b0;

    // Carry-lookahead logic for 8 bits:
    // c[i+1] = g[i] | (p[i] & c[i])
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    assign s = p ^ c[7:0]; // sum bits: p XOR carry-in per bit

    // Overflow for signed addition is carry into MSB XOR carry out of MSB
    assign overflow = c[7] ^ c[8];

endmodule