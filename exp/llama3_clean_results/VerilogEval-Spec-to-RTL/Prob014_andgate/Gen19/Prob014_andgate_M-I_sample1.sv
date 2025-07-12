// Module: TopModule
// Description: Direct implementation of a 2-input AND gate for optimization.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Implement a 2-input AND gate directly within the TopModule
always @(*) begin
    // Procedural assignment to implement the AND logic
    out = a & b;
end

endmodule