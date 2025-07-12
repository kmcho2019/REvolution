module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal for counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] counter;  // 16-bit reg to store the current counter value

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero if reset signal is active
        counter <= 16'd0;
    end else begin
        // Check the up_down control signal to determine counting direction
        if (up_down) begin
            // Increment the counter if up_down is high
            counter <= counter + 1;
        end else begin
            // Decrement the counter if up_down is low
            counter <= counter - 1;
        end
    end
end

// Assign the current counter value to the output port
assign count = counter;

endmodule