module up_down_counter(
    input clk,  // Clock signal
    input reset,  // Reset signal
    input up_down,  // Control signal to determine counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] count_reg;  // Internal 16-bit register to store the counter value

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero when the reset signal is active
        count_reg <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment the counter when the up_down signal is high
            count_reg <= count_reg + 1;
        end else begin
            // Decrement the counter when the up_down signal is low
            count_reg <= count_reg - 1;
        end
    end
end

// Assign the internal register value to the output port
assign count = count_reg;

endmodule