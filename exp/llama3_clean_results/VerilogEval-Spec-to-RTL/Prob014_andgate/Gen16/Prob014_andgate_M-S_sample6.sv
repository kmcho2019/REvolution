// Module: TopModule
// Description: The top-level module implementing a 2-input AND gate.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);
    
    // Implement the AND operation directly within TopModule
    assign out = a & b;
    
endmodule