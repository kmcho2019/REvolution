module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintaining the direct implementation for simplicity and efficiency
// Adding a comment to highlight consideration for low-power synthesis
// The specific attribute or directive for low-power optimization may vary depending on the synthesis tool
// For example, some tools might support attributes like (* power_optimization = "high" *) or similar
assign f = (x2 & ~x3) | (x1 & x3);

endmodule