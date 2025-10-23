// Refactored TopModule that implements a NOR gate using an always block
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    // Implement the NOR gate logic within an always block
    always @(*) begin
        // Invert the result of the OR operation to get the NOR gate output
        out = ~(a | b);
    end
endmodule