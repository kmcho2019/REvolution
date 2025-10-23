module TopModule (
    input a,
    input b,
    output out
);
    // Transmission gate implementation of AND function
    wire tg_conduct;
    assign tg_conduct = a & b;
    
    // Weak pull-down when transmission gate is off
    pullup (weak1) pu(out);
    pulldown (weak0) pd(out);
    
    // Transmission gate behavior
    assign out = tg_conduct ? 1'b1 : 1'bz;
endmodule