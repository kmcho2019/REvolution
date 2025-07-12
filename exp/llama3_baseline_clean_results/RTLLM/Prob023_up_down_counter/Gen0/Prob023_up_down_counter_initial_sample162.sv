module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal for counting direction
    output [15:0] count  // 16-bit counter output
);

reg [15:0] count_reg;  // Internal register to hold the counter value

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset is active
        count_reg <= 16'd0;
    end else if (up_down) begin
        // Increment the counter when up_down is high
        count_reg <= count_reg + 1;
    end else begin
        // Decrement the counter when up_down is low
        count_reg <= count_reg - 1;
    end
end

assign count = count_reg;  // Continuous assignment to output the current counter value

endmodule