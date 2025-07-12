module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire na, nb, nc;
    
    assign na = ~a;
    assign nb = ~b;
    assign nc = ~c;
    assign out = ~(na & nb & nc);
endmodule