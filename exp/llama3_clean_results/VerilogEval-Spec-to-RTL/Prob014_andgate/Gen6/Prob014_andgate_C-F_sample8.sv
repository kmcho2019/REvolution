// TopModule: A 2-input AND gate implemented using an always block.
module TopModule(
    input  a,  // First input of the AND gate.
    input  b,  // Second input of the AND gate.
    output reg out  // Output of the AND gate.
);

// The always block is sensitive to changes in inputs a and b.
// It updates the output 'out' based on the logical AND of a and b.
always @(*) begin
    out = a & b;  // Perform the AND operation and assign the result to out.
end

endmodule