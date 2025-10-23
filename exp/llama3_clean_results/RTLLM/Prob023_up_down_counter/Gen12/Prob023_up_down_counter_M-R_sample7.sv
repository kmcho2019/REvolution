module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;

// Calculate next state
assign next_count = (up_down) ? (count + 1) : (count - 1 + 65536);

// Update counter value
always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count % 65536;
    end
end

endmodule