module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // First level OR gate combining a and b
    wire a_or_b;
    or g1(a_or_b, a, b);
    
    // Final OR combining intermediate result with c
    or g2(out, a_or_b, c);
endmodule