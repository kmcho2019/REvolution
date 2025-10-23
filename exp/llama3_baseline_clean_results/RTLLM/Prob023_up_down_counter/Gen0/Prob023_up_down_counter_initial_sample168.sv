module up_down_counter(
    input clk,          // Clock signal
    input reset,        // Reset signal
    input up_down,      // Control signal for counting direction
    output [15:0] count // 16-bit output representing the current counter value
);

reg [15:0] count_reg;  // 16-bit register to store the current count value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero when the reset signal is active
        count_reg <= 16'd0;
    end else begin
        // Increment the counter when up_down is high
        if (up_down) begin
            count_reg <= count_reg + 1;
        end 
        // Decrement the counter when up_down is low
        else begin
            count_reg <= count_reg - 1;
        end
    end
end

assign count = count_reg;  // Assign the current count value to the output port

endmodule