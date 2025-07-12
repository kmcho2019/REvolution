module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // First level NOR: a and b
    wire nor_ab = ~(a | b);
    
    // Second level NOR: combine with c and invert to get final output
    assign out = ~(nor_ab | c);
endmodule