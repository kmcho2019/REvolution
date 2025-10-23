module up_down_counter(
    input clk,        // Clock signal
    input reset,      // Reset signal
    input up_down,    // Control signal for increment/decrement
    output [15:0] count // 16-bit output for current counter value
);

reg [15:0] count_reg; // Internal 16-bit register to store the count

always @(posedge clk) begin
    if (reset) begin
        // Reset counter to zero when reset is active
        count_reg <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment counter when up_down is high
            count_reg <= count_reg + 1;
        end else begin
            // Decrement counter when up_down is low
            count_reg <= count_reg - 1;
        end
    end
end

assign count = count_reg; // Assign the internal register value to the output

endmodule