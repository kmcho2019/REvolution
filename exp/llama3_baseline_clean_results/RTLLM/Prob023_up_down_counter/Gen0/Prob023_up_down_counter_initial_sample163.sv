module up_down_counter(
    input clk,    // Clock signal
    input reset,  // Reset signal
    input up_down, // Control signal to determine counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] count_reg;  // Internal register to store the counter value

// Synchronous process triggered by the rising edge of the clock signal
always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero if the reset signal is active
        count_reg <= 16'd0;
    end else begin
        // Determine the counting direction based on the up_down control signal
        if (up_down) begin
            // Increment the counter if up_down is high
            count_reg <= count_reg + 1;
        end else begin
            // Decrement the counter if up_down is low
            count_reg <= count_reg - 1;
        end
    end
end

// Assign the count output the current value of the counter
assign count = count_reg;

endmodule