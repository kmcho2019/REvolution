module TopModule (
    input in1,
    input in2,
    output reg out
);
    // Refactored to use always block instead of continuous assignment
    // Demonstrates procedural implementation of the same logic
    always @(in1 or in2) begin
        out = in1 & ~in2;  // Same logic: in1 AND (NOT in2)
    end
endmodule