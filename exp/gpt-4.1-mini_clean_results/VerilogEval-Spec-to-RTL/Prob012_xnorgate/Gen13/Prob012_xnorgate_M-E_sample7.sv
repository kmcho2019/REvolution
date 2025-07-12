module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire a_and_b;
    wire nota;
    wire notb;
    wire nota_and_notb;

    assign a_and_b = a & b;
    assign nota = ~a;
    assign notb = ~b;
    assign nota_and_notb = nota & notb;
    assign out = a_and_b | nota_and_notb;
endmodule