module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Mux implementation: q = (c|d) ? (a|b) : 0
    assign q = (c || d) ? (a || b) : 1'b0;
endmodule