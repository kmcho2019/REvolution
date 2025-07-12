// 8-bit carry-lookahead adder (CLA) implementation

module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);

    wire [7:0] p;  // propagate signals
    wire [7:0] g;  // generate signals
    wire [8:0] c;  // carry signals including cin and cout

    // Initial carry-in
    assign c[0] = cin;

    // Generate propagate and generate for each bit
    assign p = a ^ b;        // propagate = a XOR b
    assign g = a & b;        // generate = a AND b

    // Carry-lookahead carry computation
    // c[i+1] = g[i] | (p[i] & c[i])
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    // Sum computation: sum = p XOR carry-in
    assign sum = p ^ c[7:0];

    // Final carry-out
    assign cout = c[8];

endmodule