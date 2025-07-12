module up_down_counter(
    input clk, // Clock signal
    input reset, // Reset signal
    input up_down, // Control signal for counting direction
    output [15:0] count // 16-bit output representing the current counter value
);

reg [15:0] count_reg; // Register to store the current count value

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero when the reset signal is active
        count_reg <= 16'd0;
    end else begin
        // If up_down is high, increment the counter; otherwise, decrement it
        if (up_down) begin
            count_reg <= count_reg + 1;
        end else begin
            count_reg <= count_reg - 1;
        end
    end
end

// Assign the count output to the current value of the counter
assign count = count_reg;

endmodule