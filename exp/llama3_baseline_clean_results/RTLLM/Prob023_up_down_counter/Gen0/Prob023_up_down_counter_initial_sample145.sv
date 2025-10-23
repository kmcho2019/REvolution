module up_down_counter(
    input           clk,         // Clock signal
    input           reset,       // Reset signal
    input           up_down,     // Control signal for counting direction
    output reg [15:0] count      // 16-bit output representing the current counter value
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset is active
        count <= 16'd0;
    end else begin
        // Based on the up_down control signal, increment or decrement the counter
        if (up_down) begin
            // Increment the counter
            count <= count + 1;
        end else begin
            // Decrement the counter, but ensure it doesn't go below 0
            count <= (count == 16'd0) ? 16'd0 : count - 1;
        end
    end
end

endmodule