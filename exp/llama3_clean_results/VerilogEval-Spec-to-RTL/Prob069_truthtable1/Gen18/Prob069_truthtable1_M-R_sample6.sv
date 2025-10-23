module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

// Refactored implementation using an always block.
always @(*) begin
    // Maintain the same logic as the original implementation but within an always block.
    f = (~x3 & x2) | (x3 & x1);
end

endmodule