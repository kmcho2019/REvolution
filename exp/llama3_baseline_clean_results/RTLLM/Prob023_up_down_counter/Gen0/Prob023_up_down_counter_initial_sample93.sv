module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal for counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] current_count;  // reg variable to store the current count value

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero if reset signal is active
        current_count <= 16'd0;
    end else begin
        // Increment or decrement the counter based on the up_down control signal
        if (up_down) begin
            // Increment the counter
            current_count <= current_count + 1;
        end else begin
            // Decrement the counter
            current_count <= current_count - 1;
        end
    end
end

// Assign the current count value to the output port
assign count = current_count;

endmodule