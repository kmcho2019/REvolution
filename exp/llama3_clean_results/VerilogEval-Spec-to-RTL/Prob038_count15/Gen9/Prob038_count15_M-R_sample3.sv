module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Explicitly define the next state logic
reg [3:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    if (reset) begin
        next_state = 4'd0; // Reset counter to 0
    end else begin
        next_state = q + 1'd1; // Increment counter
    end
end

// Sequential logic to update the current state on the positive clock edge
always @(posedge clk) begin
    q <= next_state; // Update the current state
end

endmodule