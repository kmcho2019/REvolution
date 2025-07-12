module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire p1, p2;
    // p1 is parity of inputs a and b
    assign p1 = a ^ b;
    // p2 is parity of inputs c and d
    assign p2 = c ^ d;
    // q is even parity: NOT of (p1 XOR p2)
    assign q = ~(p1 ^ p2);
endmodule