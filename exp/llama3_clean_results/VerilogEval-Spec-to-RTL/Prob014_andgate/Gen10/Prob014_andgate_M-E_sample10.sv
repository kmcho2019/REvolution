// Module: TopModule
// Description: A simple 2-input AND gate implementation using an always block.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output reg out  // Output of the AND gate
);

// Implement a 2-input AND gate using an always block
always @(*) begin
    if (a && b) begin
        out = 1'b1;  // Output is 1 if both inputs are 1
    end else begin
        out = 1'b0;  // Output is 0 otherwise
    end
end

endmodule