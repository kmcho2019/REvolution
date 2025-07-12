// Module: TopModule
// Description: A 2-input AND gate implementation combining the simplicity of continuous assignment with the flexibility of an always block.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate
);

// Implement a 2-input AND gate using an always block for flexibility
always @(*) begin
    // Maintain simplicity by using a straightforward procedural assignment for the AND logic
    out = a & b;
end

endmodule