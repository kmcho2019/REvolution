module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal implementation using basic gates
    assign q = (a | b) & (c | d);
endmodule