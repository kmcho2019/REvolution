module TopModule (
    input a,
    input b,
    output out
);
    wire ab_eq = ~(a ^ b);
    wire ab_neq = a ^ b;
    
    // Transmission gate style implementation
    assign out = (ab_eq) ? 1'b1 : 
                 (ab_neq) ? 1'b0 : 
                 1'bx; // should never happen
endmodule