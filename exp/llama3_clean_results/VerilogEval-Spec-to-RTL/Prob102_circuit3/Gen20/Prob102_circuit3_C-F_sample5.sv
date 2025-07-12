module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Declare wires to connect the OR gates
    wire ab_or;
    wire cd_or;
    
    // Compute the OR of (a, b) and (c, d)
    assign ab_or = a || b;
    assign cd_or = c || d;
    
    // Compute the output q using the results of the OR operations
    assign q = ab_or && cd_or;
    
endmodule