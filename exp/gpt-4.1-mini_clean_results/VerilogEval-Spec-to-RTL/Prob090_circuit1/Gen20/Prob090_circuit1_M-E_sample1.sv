module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire nota, notb;

    // Invert a and b using NOR gates with tied inputs
    nor (nota, a, a); // nota = ~a
    nor (notb, b, b); // notb = ~b

    // NOR of inverted inputs to realize AND
    nor (q, nota, notb); // q = ~(~a + ~b) = a & b

endmodule