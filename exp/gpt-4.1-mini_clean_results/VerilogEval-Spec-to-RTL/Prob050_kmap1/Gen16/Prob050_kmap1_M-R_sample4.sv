module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire bc_or, bcn_and;

    assign bc_or = b | c;
    assign bcn_and = (~b) & (~c) & a;
    assign out = bc_or | bcn_and;
endmodule