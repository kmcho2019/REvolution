module TopModule(
    input  a,
    input  b,
    output out
);
    wire a_and_b;
    wire nota_and_notb;

    assign a_and_b = a & b;
    assign nota_and_notb = (~a) & (~b);
    assign out = a_and_b | nota_and_notb;
endmodule