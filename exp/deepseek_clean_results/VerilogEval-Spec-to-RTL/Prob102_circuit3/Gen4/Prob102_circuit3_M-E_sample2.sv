module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire sel_ab = a | b;  // Control signal for first MUX
    wire sel_cd = c | d;  // Control signal for second MUX
    
    wire mux_ab = sel_ab ? a : b;
    wire mux_cd = sel_cd ? c : d;
    
    assign q = mux_ab & mux_cd;

endmodule