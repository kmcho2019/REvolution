module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire na, nb;

    // Invert inputs using NOR operation (NOR(x,x) == NOT x)
    assign na = ~(a | a);
    assign nb = ~(b | b);
    // AND realized as NOR of inverted inputs
    assign q = ~(na | nb);
endmodule