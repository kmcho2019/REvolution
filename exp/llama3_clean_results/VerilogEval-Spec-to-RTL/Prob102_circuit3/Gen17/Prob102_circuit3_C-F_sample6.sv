// Define a module for the OR gate to enhance modularity
module OR_Gate(
    input  a,
    input  b,
    output q
);
    
    // Assign the result of the OR operation to the output
    assign q = a | b;
    
endmodule

// Define the TopModule that implements the combinational circuit
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Declare wires to connect the OR gates
    wire ab_or_result;
    wire cd_or_result;
    
    // Instantiate the OR gates
    OR_Gate ab_or_gate(.a(a), .b(b), .q(ab_or_result));
    OR_Gate cd_or_gate(.a(c), .b(d), .q(cd_or_result));
    
    // Compute the output q by ANDing the results of the OR gates
    assign q = ab_or_result & cd_or_result;
    
endmodule