module TopModule (
    input a,
    input b,
    output out
);
    // Optimal NOR gate implementation
    assign out = ~(a | b);
    // Alternative equivalent implementations would not improve PPA:
    // assign out = (~a) & (~b);
    // nor g1(out, a, b);
endmodule