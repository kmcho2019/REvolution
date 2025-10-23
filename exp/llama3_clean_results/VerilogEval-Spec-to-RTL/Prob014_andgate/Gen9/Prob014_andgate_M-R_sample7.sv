// Module: TopModule
// Description: A simple 2-input AND gate implementation using an always block.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate
);

// Implement a 2-input AND gate using an always block
always @(*) begin
    out = a & b;
end

endmodule