module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire sel0 = a | b;
    wire sel1 = c | d;
    
    // Implement truth table as mux
    assign q = (sel1 & sel0) ? 1'b1 :
               (sel1 & ~sel0) ? 1'b1 :
               (~sel1 & sel0) ? 1'b1 :
               1'b0;
endmodule