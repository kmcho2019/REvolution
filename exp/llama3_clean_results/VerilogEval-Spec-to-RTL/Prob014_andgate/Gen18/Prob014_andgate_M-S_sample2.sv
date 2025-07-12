// Module: TopModule
// Description: A simplified top-level module implementing a 2-input AND gate.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Directly implement the 2-input AND gate using continuous assignment
assign out = a & b;

endmodule