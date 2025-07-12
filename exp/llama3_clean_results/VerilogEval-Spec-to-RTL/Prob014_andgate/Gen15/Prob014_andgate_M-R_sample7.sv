// Refactored module using an always block
module TopModule(
    // Input signals
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    // Output signal
    output logic out  // Output of the AND gate
);

// Implementing a 2-input AND gate using an always block
always @(*) begin
    // Perform the AND operation and assign the result to the output
    out = a & b;
end

endmodule