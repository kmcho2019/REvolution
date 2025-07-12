// Module: AndGate
// Description: A basic 2-input AND gate implementation using procedural assignment.
module AndGate(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// To optimize for high-speed implementations, consider using synthesis options
// that favor high-speed library cells or technology nodes.
// For low-power optimization, explore synthesis options or technology libraries
// that favor low-power implementations.

// Implement a 2-input AND gate using procedural assignment
always @(*) begin
    // Procedural assignment to implement the AND logic
    out = a & b;
end

// When synthesizing, consider the PPA metrics and explore different synthesis
// tools or target technologies to minimize area and power consumption while
// maintaining the required functionality.

endmodule

// Module: TopModule
// Description: The top-level module that instantiates the AndGate module.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Instantiate the AndGate module
AndGate and_gate_instance(
  .a(a),  // Connect input 'a' to the AndGate instance
  .b(b),  // Connect input 'b' to the AndGate instance
  .out(out)  // Connect output 'out' to the AndGate instance
);

endmodule