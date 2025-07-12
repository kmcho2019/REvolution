module up_down_counter(
    input clk,        // Clock signal
    input reset,      // Reset signal
    input up_down,    // Control signal for counting direction
    output [15:0] count // 16-bit output representing the current counter value
);

reg [15:0] count_reg; // Internal register to hold the counter value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero when the reset signal is active
        count_reg <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment the counter when up_down is high
            count_reg <= count_reg + 1;
        end else begin
            // Decrement the counter when up_down is low
            count_reg <= count_reg - 1;
        end
    end
end

assign count = count_reg; // Assign the internal counter value to the output

endmodule