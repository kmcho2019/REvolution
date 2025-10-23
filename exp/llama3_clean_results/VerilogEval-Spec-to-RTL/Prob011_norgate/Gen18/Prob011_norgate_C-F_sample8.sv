// TopModule that implements a NOR gate using an always block
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Implementing NOR gate within an always block
always @(*) begin
    // Direct implementation of NOR operation within the always block
    // Invert the result of the OR operation
    out = ~(a | b);  // NOR operation
end

endmodule