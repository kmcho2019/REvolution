module up_down_counter(
    input clk,          // Clock signal
    input reset,        // Reset signal
    input up_down,      // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Synchronous process triggered by the rising edge of the clock signal
always @ (posedge clk) begin
    // If the reset signal is active, reset the counter to zero
    if (reset) begin
        count <= 16'd0;
    end
    // If the reset signal is not active, proceed with the counting process
    else begin
        // If the up_down control signal is high, increment the counter
        if (up_down) begin
            count <= count + 1;
        end
        // If the up_down control signal is low, decrement the counter
        else begin
            count <= count - 1;
        end
    end
end

endmodule