module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // 'd' is don't-care, not used in the logic
    output reg out
);

// Using an always block with a sensitivity list to ensure the output is updated when any input changes
always @(*) begin
    // Implementing the required logic using a simple and efficient expression
    // This expression directly implements the Karnaugh map, minimizing the use of operators and reducing area usage
    out = a || (!a &&!b && c);
end

endmodule