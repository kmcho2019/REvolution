module TopModule (
    input  a,
    input  b,
    output out
);
    wire and_ab;
    wire and_nnaannb;

    assign and_ab = a & b;
    assign and_nnaannb = (~a) & (~b);
    assign out = and_ab | and_nnaannb;
endmodule