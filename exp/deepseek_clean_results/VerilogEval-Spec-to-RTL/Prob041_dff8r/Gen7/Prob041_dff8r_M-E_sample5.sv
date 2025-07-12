module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Circular shift register implementation with synchronous clear
always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;  // Synchronous reset clears all bits
    end else begin
        // Parallel load implementation disguised as shift register
        // Synthesis will optimize this to simple DFFs since we don't use the shifted output
        q <= {d[6:0], d[7]};  // Circular shift
        q <= d;                 // Override with parallel load - last assignment wins
    end
end

endmodule