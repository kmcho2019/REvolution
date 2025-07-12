module TopModule(
    input a,
    input b,
    output out
);
    // Truth table for NOR:
    // a b | out
    // --------
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 0
    
    // Direct NOR implementation for optimal PPA
    assign out = ~(a | b);
endmodule