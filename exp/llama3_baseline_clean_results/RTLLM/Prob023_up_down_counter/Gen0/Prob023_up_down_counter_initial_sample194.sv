module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal to determine counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] counter;  // reg variable to hold the current counter value

always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to zero if the reset signal is active
        counter <= 16'd0;
    end else begin
        // Increment or decrement the counter based on the up_down control signal
        if (up_down) begin
            // Increment the counter if up_down is high
            counter <= counter + 1;
        end else begin
            // Decrement the counter if up_down is low
            counter <= counter - 1;
        end
    end
end

assign count = counter;  // Assign the updated counter value to the count output

endmodule