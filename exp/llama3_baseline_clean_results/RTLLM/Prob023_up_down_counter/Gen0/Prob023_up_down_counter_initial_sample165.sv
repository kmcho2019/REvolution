module up_down_counter (
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal for counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] counter;  // 16-bit reg to store the counter value

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero
        counter <= 16'd0;
    end else begin
        // Check the up_down control signal to determine the counting direction
        if (up_down) begin
            // Increment the counter
            counter <= counter + 1;
        end else begin
            // Decrement the counter
            counter <= counter - 1;
        end
    end
end

assign count = counter;  // Assign the counter value to the output

endmodule