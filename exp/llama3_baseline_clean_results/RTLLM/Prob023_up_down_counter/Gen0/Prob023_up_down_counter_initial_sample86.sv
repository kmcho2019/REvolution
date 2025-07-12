module up_down_counter(
    input clk,          // Clock signal
    input reset,        // Reset signal
    input up_down,      // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @(posedge clk) begin
    if (reset) begin
        // If reset is active, reset the counter to zero
        count <= 16'd0;
    end else begin
        // If up_down is high, increment the counter
        if (up_down) begin
            count <= count + 1;
        end 
        // If up_down is low, decrement the counter
        else begin
            count <= count - 1;
        end
    end
end

endmodule