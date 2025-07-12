module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // First level pattern selection
    wire pattern_sel = c ^ d;
    
    // Second level output selection
    wire output_sel = a ^ b;
    
    // Final output mux
    assign out = output_sel ? ~pattern_sel : pattern_sel;
endmodule