module up_down_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count // 16-bit counter output
);

// Synchronous process to update the counter value
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero
        count <= 16'd0;
    end else begin
        // Update the counter based on the up_down control signal
        if (up_down) begin
            // Increment the counter
            count <= count + 1;
        end else begin
            // Decrement the counter, but prevent it from going below zero
            count <= (count > 16'd0) ? count - 1 : 16'd0;
        end
    end
end

endmodule