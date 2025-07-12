module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal to determine counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] count_reg;  // 16-bit reg to store the counter value

// Synchronous process triggered by the rising edge of the clock signal
always @(posedge clk) begin
    if (reset) begin  // If reset signal is active, reset the counter to zero
        count_reg <= 16'd0;
    end else if (up_down) begin  // If up_down signal is high, increment the counter
        count_reg <= count_reg + 1;
    end else begin  // If up_down signal is low, decrement the counter
        count_reg <= count_reg - 1;
    end
end

// Continuous assignment to output the current counter value
assign count = count_reg;

endmodule