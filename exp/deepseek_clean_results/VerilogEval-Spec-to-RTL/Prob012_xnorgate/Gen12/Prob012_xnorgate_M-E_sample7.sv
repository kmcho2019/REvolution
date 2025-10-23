module TopModule (
    input a,
    input b,
    output out
);
    wire ab_eq = ~(a ^ b);  // XNOR condition
    wire ab_neq = a ^ b;    // XOR condition
    
    // Transmission gate implementation
    assign out = (ab_eq) ? 1'b1 : 
                 (ab_neq) ? 1'b0 : 
                 1'bz;  // High-Z for simulation safety
    
    // Alternative implementation showing transistor-level thinking
    // assign out = (a & b) | (~a & ~b);
endmodule