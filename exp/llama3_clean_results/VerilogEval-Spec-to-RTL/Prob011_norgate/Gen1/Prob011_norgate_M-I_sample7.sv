module TopModule(
    input  a,
    input  b,
    output out
);
    
    // The current implementation is already optimal.
    // For educational purposes, an alternative using the AND operator (~a & ~b) could be considered,
    // but in terms of logic, it's essentially the same as ~(a | b) due to De Morgan's laws.
    assign out = ~(a | b);
    
endmodule