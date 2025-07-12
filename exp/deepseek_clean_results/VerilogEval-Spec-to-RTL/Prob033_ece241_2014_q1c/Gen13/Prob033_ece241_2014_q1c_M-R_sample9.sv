module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;

    // Carry computation with symmetric 2-3-3 grouping
    wire c0 = g[0];
    wire c1 = g[1] | (p[1] & c0);
    
    wire c2 = g[2] | (p[2] & c1);
    wire c3 = g[3] | (p[3] & c2);
    wire c4 = g[4] | (p[4] & c3);
    
    wire c5 = g[5] | (p[5] & c4);
    wire c6 = g[6] | (p[6] & c5);
    wire c7 = g[7] | (p[7] & c6);

    // Sum computation
    assign s = p ^ {c6, c5, c4, c3, c2, c1, c0, 1'b0};

    // Overflow detection
    assign overflow = ~(a[7] ^ b[7]) & (a[7] ^ s[7]);
endmodule