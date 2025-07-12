module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimal implementation: f is true when (x3=0 and x2=1) or (x3=1 and x1=1)
    assign f = (~x3 & x2) | (x3 & x1);
endmodule