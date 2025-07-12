// Top-level module that directly implements the required logic
// in a modular and hierarchical manner.

module OR_Gate(
    input  a,
    input  b,
    output q
);
    
    // Direct implementation of an OR gate
    assign q = a | b;
    
endmodule

module AND_Gate(
    input  a,
    input  b,
    output q
);
    
    // Direct implementation of an AND gate
    assign q = a & b;
    
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    wire ab_or, cd_or;
    
    // Instantiate OR gates for (a, b) and (c, d)
    OR_Gate u_ab_or(.a(a), .b(b), .q(ab_or));
    OR_Gate u_cd_or(.a(c), .b(d), .q(cd_or));
    
    // Instantiate an AND gate for the final result
    AND_Gate u_and(.a(ab_or), .b(cd_or), .q(q));
    
endmodule

// Alternatively, a more direct implementation without separate modules for each gate
module TopModuleDirect(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Direct implementation of the required logic
    assign q = (a | b) & (c | d);
    
endmodule