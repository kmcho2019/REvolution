module TopModule (
    input  a,
    input  b,
    output q
);
    wire nota, notb, nora_norb;

    assign nota = ~a;
    assign notb = ~b;
    assign nora_norb = ~(nota | notb);
    assign q = nora_norb;

endmodule