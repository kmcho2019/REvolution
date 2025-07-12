module up_down_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count // 16-bit counter output
);

// Synchronous process triggered by the rising edge of the clock signal
always @(posedge clk) begin
    // If the reset signal is active, reset the counter to zero
    if (reset) begin
        count <= 16'd0;
    end
    // If the up_down control signal is high, increment the counter
    else if (up_down) begin
        count <= count + 1;
    end
    // If the up_down control signal is low, decrement the counter
    else begin
        count <= count - 1;
    end
end

endmodule