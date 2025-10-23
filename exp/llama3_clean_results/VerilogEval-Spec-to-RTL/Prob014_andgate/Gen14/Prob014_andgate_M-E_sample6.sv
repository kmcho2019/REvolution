// Module: AndGate
// Description: A basic 2-input AND gate implementation using procedural assignment.
module AndGate(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate
);

// Implement a 2-input AND gate using procedural assignment
always @(*) begin
    out = a & b;
end

endmodule

// Module: TopModule
// Description: The top-level module that instantiates the AndGate module.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Instantiate the AndGate module
AndGate and_gate_instance(
    .a(a),  // Connect input 'a' to the AndGate instance
    .b(b),  // Connect input 'b' to the AndGate instance
    .out(out)  // Connect output 'out' to the AndGate instance
);

endmodule