module TopModule(
    input clk,
    input in,
    output reg out
);

// Custom sequential logic: Incorporating XOR into the flip-flop's update
always @(posedge clk) begin
    out <= out ^ in;  // Update 'out' based on its current value and 'in'
end

// Initialize 'out' to a default value (0) for deterministic behavior
initial begin
    out = 1'b0;
end

endmodule