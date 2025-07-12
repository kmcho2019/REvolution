module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire na, nb;

    // Invert inputs using NOR operation: NOR(x,x) = NOT x
    assign na = ~(a | a);
    assign nb = ~(b | b);

    // NOR the inverted inputs to get AND
    assign q = ~(na | nb);

endmodule