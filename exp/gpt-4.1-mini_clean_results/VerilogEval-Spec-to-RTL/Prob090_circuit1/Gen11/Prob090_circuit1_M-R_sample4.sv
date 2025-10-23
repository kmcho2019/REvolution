module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire na, nb;

    // Invert inputs using NOR(x,x) behavior
    assign na = ~(a | a);
    assign nb = ~(b | b);
    // NOR of inverted inputs to produce AND function
    assign q = ~(na | nb);
endmodule