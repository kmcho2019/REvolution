module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to a known value (e.g., 0) to ensure predictable behavior
initial out = 1'b0;

// Single always block for both D flip-flop and XOR operation
always @(posedge clk) begin
    out <= in ^ out; // Update 'out' with the result of the XOR operation on the rising edge of the clock
end

endmodule