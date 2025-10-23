// Module: TopModule
// Description: The top-level module that implements a 2-input AND gate.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Implement the 2-input AND gate using continuous assignment
assign out = a & b;

endmodule