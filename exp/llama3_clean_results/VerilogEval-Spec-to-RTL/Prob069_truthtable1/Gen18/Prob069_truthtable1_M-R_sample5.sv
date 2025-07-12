module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Refactored implementation using an always block for combinational logic
// This approach maintains the same functionality but offers a procedural perspective
// on the logic, which can be beneficial for more complex designs.

always @(*) begin
    // The logic expression remains the same, but now within an always block
    // This ensures f is updated whenever any input changes, maintaining combinational behavior
    f = (~x3 & x2) | (x3 & x1);
end

endmodule