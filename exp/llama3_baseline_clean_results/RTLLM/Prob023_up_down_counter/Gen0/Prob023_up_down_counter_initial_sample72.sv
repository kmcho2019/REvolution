module up_down_counter(
    input clk,    // Clock signal
    input reset,  // Reset signal
    input up_down, // Control signal for counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] counter; // 16-bit reg to store the current counter value

// Synchronous process triggered by the rising edge of the clock signal
always @ (posedge clk) begin
    if (reset) begin // If reset signal is active, reset the counter to zero
        counter <= 16'd0;
    end else begin // Otherwise, update the counter based on the up_down control signal
        if (up_down) begin // If up_down is high, increment the counter
            counter <= counter + 1;
        end else begin // If up_down is low, decrement the counter
            counter <= counter - 1;
        end
    end
end

// Assign the current counter value to the count output
assign count = counter;

endmodule