module TopModule(
    input  a,
    input  b,
    output reg out
);

// Implement a 2-input AND gate using an always block
// This allows for more flexibility if the module needs to be extended
always @(*) begin
    // Perform the AND operation
    out = a & b;
end

endmodule