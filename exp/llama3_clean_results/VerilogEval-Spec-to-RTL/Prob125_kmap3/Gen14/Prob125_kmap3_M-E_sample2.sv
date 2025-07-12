module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out
);

// Hierarchical implementation using a combination of logic
always @(*) begin
    // First level: Determine output based on 'a'
    if (a) begin
        out = 1'b1; // If 'a' is 1, 'out' is always 1
    end else begin
        // Second level: Use 'b' and 'c' to determine output
        if (b) begin
            out = 1'b1; // If 'b' is 1, 'out' is always 1
        end else begin
            // Final decision based on 'c'
            out = c; // If 'c' is 1, 'out' is 1; if 'c' is 0, 'out' is 0
        end
    end
end

endmodule