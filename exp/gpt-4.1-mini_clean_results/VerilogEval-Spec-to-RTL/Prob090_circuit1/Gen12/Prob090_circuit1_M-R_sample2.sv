module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire na, nb;

    // Invert inputs by NOR-ing each input with itself (NOR(x,x) = NOT x)
    assign na = ~(a | a);
    assign nb = ~(b | b);

    // AND implemented as NOR of inverted inputs
    assign q = ~(na | nb);

endmodule