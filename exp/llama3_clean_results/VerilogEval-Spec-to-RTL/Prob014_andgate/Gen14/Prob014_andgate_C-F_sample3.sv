// Module: TopModule
// Description: A simple 2-input AND gate implementation combining the best of both examples.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate
);

// Implement a 2-input AND gate using an always block with procedural assignment
always @(*) begin
    // Minimal and efficient logic for the AND gate
    out = a & b;
end

endmodule