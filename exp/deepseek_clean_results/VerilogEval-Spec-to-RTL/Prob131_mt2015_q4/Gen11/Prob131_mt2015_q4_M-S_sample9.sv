module TopModule(
    input x,
    input y,
    output z
);
    // Combined logic: z = [(x^y)&x | (~x&~y | x&y)] ^ [(x^y)&x & (~x&~y | x&y)]
    // Simplified to: z = [(x^y)&x] ^ [~x&~y | x&y]
    assign z = ((x ^ y) & x) ^ ((~x & ~y) | (x & y));
endmodule