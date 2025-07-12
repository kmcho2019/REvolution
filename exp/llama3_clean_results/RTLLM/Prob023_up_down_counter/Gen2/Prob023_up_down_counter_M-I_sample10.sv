module up_down_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Internal signal to gate the clock
reg enable;

// Clock gating logic
always @(*) begin
    if (reset || (up_down == 1'b1 && count == 16'd65535) || (up_down == 1'b0 && count == 16'd0)) begin
        enable = 1'b0; // Disable clock when counter is at its limits or reset
    end else begin
        enable = 1'b1;
    end
end

// Synchronous process triggered by the gated clock
always @ (posedge clk) begin
    if (enable) begin
        if (reset) begin
            // Reset the counter to zero when the reset signal is active
            count <= 16'd0;
        end else if (up_down) begin
            // Increment the counter when up_down is high
            count <= count + 1;
        end else begin
            // Decrement the counter when up_down is low
            count <= count - 1;
        end
    end
end

endmodule