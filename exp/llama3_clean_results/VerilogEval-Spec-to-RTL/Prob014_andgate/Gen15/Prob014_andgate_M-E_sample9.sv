// Module: AndGate
// Description: A basic 2-input AND gate.
module AndGate(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);
    
    // Implement the AND operation
    assign out = a & b;
    
endmodule

// Module: TopModule
// Description: The top-level module instantiating the AndGate.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);
    
    // Instantiate the AndGate module
    AndGate and_inst(
        .a(a),  // Connect input a to the AndGate instance
        .b(b),  // Connect input b to the AndGate instance
        .out(out)  // Connect output out to the AndGate instance
    );
    
endmodule