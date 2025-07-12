// Define a module for the OR gate to maintain modularity
module OR_Gate(
    input  a,
    input  b,
    output q
);
    
    // Directly assign the OR operation result to output q
    assign q = a | b;
    
endmodule

// Define the TopModule that combines the OR gates and computes the output q
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
    
    // Instantiate the OR gates
    OR_Gate u_ab_or(.a(a),.b(b),.q(ab_or));
    OR_Gate u_cd_or(.a(c),.b(d),.q(cd_or));
    
    // Compute the output q using the results of the OR gates
    assign q = ab_or | cd_or; // Changed from '&' to '|'
    
endmodule