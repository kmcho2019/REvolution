module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Intermediate signals for ab combinations
    wire ab00 = ~a & ~b;
    wire ab01 = ~a & b;
    wire ab11 = a & b;
    wire ab10 = a & ~b;
    
    // First level muxes for each cd row
    wire row00 = (ab01 | ab10) ? 1'b1 : 1'b0;
    wire row01 = (ab00 | ab11) ? 1'b1 : 1'b0;
    wire row11 = (ab01 | ab10) ? 1'b1 : 1'b0;
    wire row10 = (ab00 | ab11) ? 1'b1 : 1'b0;
    
    // Final output selection based on cd
    assign out = (~c & ~d) ? row00 :
                 (~c &  d) ? row01 :
                 ( c &  d) ? row11 :
                             row10;
endmodule