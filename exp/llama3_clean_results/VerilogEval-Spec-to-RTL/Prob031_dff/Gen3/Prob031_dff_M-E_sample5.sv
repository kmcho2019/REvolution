module TopModule(
    input clk,
    input d,
    output reg q
);

// Using a multiplexer to select between current state and new data
always @(d, clk, q) begin
    if (clk) begin
        q <= d; // Update output with new data when clock is high
    end else begin
        q <= q; // Hold current state when clock is low
    end
end

// Initialize q for defined behavior at startup
initial q = 1'b0;

endmodule