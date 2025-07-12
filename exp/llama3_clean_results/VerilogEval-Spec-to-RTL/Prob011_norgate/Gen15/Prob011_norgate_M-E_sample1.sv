// Module TopModule implements a NOR gate using an always block with conditional statements.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Implement the NOR operation within an always block using conditional statements.
always @(*) begin
    // Evaluate the inputs using an if-else statement and assign the output accordingly.
    if (a == 1'b0 && b == 1'b0) begin
        out = 1'b1;  // Output is 1 only when both inputs are 0.
    end else begin
        out = 1'b0;  // Output is 0 for any other input combination.
    end
end

// This implementation provides a distinct approach to implementing a NOR gate, utilizing conditional statements for clarity and flexibility.
endmodule