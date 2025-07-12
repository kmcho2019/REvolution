// Superior Module TopModule implements an XNOR gate using an always block with direct assignment
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Use an always block with a direct assignment to the output signal
always @(*) begin
    // The XNOR operation outputs 1 when both inputs are the same, and outputs 0 otherwise
    out = ~(a ^ b); // Directly assign the result of the XNOR operation
end

endmodule