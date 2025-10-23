// Module for a basic OR gate
module OR_Gate(
    input  a,
    input  b,
    output q
);
    
    // Directly assign the OR operation result to output q
    assign q = a | b;
    
endmodule

// Top-level module implementing the combinational circuit
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Instantiate OR gate modules for (a, b) and (c, d)
    wire ab_or, cd_or;
    OR_Gate u_ab_or(.a(a), .b(b), .q(ab_or));
    OR_Gate u_cd_or(.a(c), .b(d), .q(cd_or));
    
    // Compute the final output q by ANDing the results of the two OR operations
    assign q = ab_or & cd_or;
    
endmodule