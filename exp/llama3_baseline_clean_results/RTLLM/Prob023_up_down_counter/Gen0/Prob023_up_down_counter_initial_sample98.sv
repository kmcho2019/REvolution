module up_down_counter(
    input clk,          // Clock signal
    input reset,        // Reset signal
    input up_down,      // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Synchronous process triggered by the rising edge of the clock signal
always @(posedge clk) begin
    // If reset is active, reset the counter to zero
    if (reset) begin
        count <= 16'd0;
    end
    // If reset is not active, check the up_down control signal
    else begin
        // If up_down is high, increment the counter
        if (up_down) begin
            count <= count + 1;
        end
        // If up_down is low, decrement the counter
        else begin
            count <= count - 1;
        end
    end
end

endmodule