// TopModule implements a NOR gate using a modular approach with an always block and conditional statements.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Implement the NOR operation within an always block using conditional statements.
always @(*) begin
    // Evaluate the inputs using an if-else statement and assign the output accordingly.
    if (~a && ~b) begin
        out = 1'b1;  // Output is 1 only when both inputs are 0.
    end else begin
        out = 1'b0;  // Output is 0 for any other input combination.
    end
end

// This implementation combines modularity with direct conditional logic for a NOR gate.
endmodule