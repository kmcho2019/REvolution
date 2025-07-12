module TopModule (
    input  clk,
    input  ar,    // Active-high async reset
    input  d,
    output q
);

wire master_out;  // Connection between master and slave latches

// Master latch (transparent when clk is low)
always @(ar or d or clk) begin
    if (ar) begin
        master_out <= 1'b0;  // Async reset
    end else if (~clk) begin
        master_out <= d;     // Capture input when clk is low
    end
end

// Slave latch (transparent when clk is high)
always @(ar or master_out or clk) begin
    if (ar) begin
        q <= 1'b0;           // Async reset
    end else if (clk) begin
        q <= master_out;     // Update output when clk is high
    end
end

endmodule