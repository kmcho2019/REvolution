module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire temp1, temp2;

    // NAND gates
    assign temp1 = ~(a & b);
    assign temp2 = ~(c & d);
    assign q = ~(temp1 & temp2);

endmodule