// Module: TopModule
// Description: A simple 2-input AND gate implementation using an always block.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate, declared as reg for use in always block
);

// Implement a 2-input AND gate using an always block
always @(*) begin
    out = a & b;  // Perform the AND operation
end

endmodule