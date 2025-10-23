module TopModule(
    input  a,
    input  b,
    output wire out
);

// Implement a 2-input AND gate using an always block for flexibility
// This allows for more functionality extensions if needed
always @(*) begin
    // Perform the AND operation
    out = a & b;
end

endmodule