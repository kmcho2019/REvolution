module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;

    // Propagate and generate terms for entire 64-bit width
    wire [63:0] p = A ^ B_comp;
    wire [63:0] g = A & B_comp;

    // Carry computation using Brent-Kung parallel prefix structure
    // First level: 2-bit groups
    wire [63:0] g1, p1;
    assign {g1[0], p1[0]} = {g[0], p[0]};
    genvar i;
    for (i=1; i<64; i=i+1) begin
        assign g1[i] = g[i] | (p[i] & g[i-1]);
        assign p1[i] = p[i] & p[i-1];
    end

    // Second level: 4-bit groups
    wire [63:0] g2, p2;
    assign {g2[1:0], p2[1:0]} = {g1[1:0], p1[1:0]};
    for (i=3; i<64; i=i+2) begin
        assign g2[i]   = g1[i]   | (p1[i]   & g1[i-2]);
        assign g2[i-1] = g1[i-1] | (p1[i-1] & g1[i-2]);
        assign p2[i]   = p1[i]   & p1[i-2];
        assign p2[i-1] = p1[i-1] & p1[i-2];
    end

    // Final carry computation
    assign carry[0] = 1'b1; // Initial carry-in for subtraction
    assign carry[1] = g1[1] | (p1[1] & carry[0]);
    for (i=2; i<64; i=i+1) begin
        assign carry[i] = g2[i] | (p2[i] & carry[(i>>2)<<1]);
    end

    // Sum computation
    assign result = p ^ {carry[62:0], 1'b1};

    /* Overflow detection:
     * Overflow occurs when signs of A and B differ and result sign differs from A
     * Simplified to: (A[63] ^ B[63]) & (A[63] ^ result[63])
     */
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule