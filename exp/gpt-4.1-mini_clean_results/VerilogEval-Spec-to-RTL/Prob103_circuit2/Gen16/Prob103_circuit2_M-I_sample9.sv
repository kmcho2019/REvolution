module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire p1, p2;

    // Intermediate XNOR stages to balance the logic
    assign p1 = ~(a ^ b);
    assign p2 = ~(c ^ d);
    assign q  = ~(p1 ^ p2);

endmodule