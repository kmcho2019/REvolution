// Module: TopModule
// Description: The top-level module that directly implements a 2-input AND gate.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Direct implementation of the AND gate using continuous assignment
assign out = a & b;  // Continuous assignment to implement the AND logic

endmodule