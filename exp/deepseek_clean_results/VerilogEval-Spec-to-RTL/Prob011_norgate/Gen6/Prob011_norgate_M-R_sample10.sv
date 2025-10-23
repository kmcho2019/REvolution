module TopModule(
    input a,
    input b,
    output out
);
    // NOR gate truth table:
    // a b | out
    // --------
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 0
    
    wire or_out;
    
    // First create the OR gate
    or(or_out, a, b);
    
    // Then invert the output
    not(out, or_out);
endmodule