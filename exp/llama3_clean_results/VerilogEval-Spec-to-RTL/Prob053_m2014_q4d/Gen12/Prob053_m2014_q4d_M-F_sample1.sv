module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Internal signal to hold the next state
reg next_out;

// Combinational logic to compute next_out
always @(*) begin
    next_out = in ^ out; // Compute next_out based on current out and in
end

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    out <= next_out; // Update out with next_out on the next clock edge
end

endmodule