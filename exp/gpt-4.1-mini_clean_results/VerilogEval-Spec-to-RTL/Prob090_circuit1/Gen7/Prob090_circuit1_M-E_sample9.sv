module TopModule (
    input  a,
    input  b,
    output q
);
    wire na, nb, nor_ab;

    assign na = ~a;
    assign nb = ~b;
    assign nor_ab = na | nb;
    assign q = ~nor_ab;
endmodule