module TopModule(
    input a,
    input b,
    output out
);
    wire na, nb;

    assign na = ~(a & a); // NAND of a with itself = NOT a
    assign nb = ~(b & b); // NAND of b with itself = NOT b

    assign out = ~(na & nb); // NAND of na and nb = NOR of a and b
endmodule