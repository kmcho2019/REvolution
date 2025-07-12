// Module: TopModule
// Description: A top-level module implementing a 2-input AND gate.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);
    
    // Directly implement the AND operation using bitwise AND
    assign out = a & b;
    
endmodule