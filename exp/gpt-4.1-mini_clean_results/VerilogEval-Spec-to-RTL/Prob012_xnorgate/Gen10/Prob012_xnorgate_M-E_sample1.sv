module TopModule(
    input  a,
    input  b,
    output out
);
    wire a_and_b;
    wire nota;
    wire notb;
    wire nota_and_notb;

    // Basic gates to form XNOR
    and u_and1 (a_and_b, a, b);
    not u_not1 (nota, a);
    not u_not2 (notb, b);
    and u_and2 (nota_and_notb, nota, notb);
    or  u_or1  (out, a_and_b, nota_and_notb);

endmodule