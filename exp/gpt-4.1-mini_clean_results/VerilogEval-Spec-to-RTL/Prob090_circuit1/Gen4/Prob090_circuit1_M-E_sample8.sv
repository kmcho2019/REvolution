module TopModule(
    input a,
    input b,
    output q
);
    wire nota, notb, or_out;
    assign nota = ~a;
    assign notb = ~b;
    assign or_out = nota | notb;
    assign q = ~or_out;
endmodule