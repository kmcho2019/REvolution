module TopModule(
    input clk,
    input in,
    output reg out
);

always @(posedge clk) begin
    // Calculate the next state directly within the sequential block
    out <= in ^ out;
end

// Initialize 'out' to a known state to avoid undefined behavior
initial begin
    out = 1'b0;
end

endmodule