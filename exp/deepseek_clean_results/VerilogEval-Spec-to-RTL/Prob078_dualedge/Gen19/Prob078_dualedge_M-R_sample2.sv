module TopModule (
    input clk,
    input d,
    output q
);

    wire clk_delayed;
    reg p, n;

    // Create delayed clock version for edge detection
    assign clk_delayed = ~clk;

    // Capture data on both edges using continuous assignments
    assign p = (clk & ~clk_delayed) ? d : p;
    assign n = (~clk & clk_delayed) ? d : n;

    // Output selection remains the same
    assign q = clk ? p : n;

endmodule