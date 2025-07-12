module up_down_counter(
    input clk,       // Clock signal
    input reset,     // Reset signal
    input up_down,   // Control signal for counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] count_reg;  // Internal register for the counter

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero
        count_reg <= 16'd0;
    end else if (up_down) begin
        // Increment the counter
        count_reg <= count_reg + 1;
    end else begin
        // Decrement the counter
        count_reg <= count_reg - 1;
    end
end

// Assign the internal register to the output port
assign count = count_reg;

endmodule