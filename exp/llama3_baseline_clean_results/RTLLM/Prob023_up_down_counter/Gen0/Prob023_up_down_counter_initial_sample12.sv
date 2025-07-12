module up_down_counter(
    input           clk,    // Clock signal
    input           reset,  // Reset signal
    input           up_down, // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // If reset signal is active, reset the counter to zero
        count <= 16'd0;
    end else begin
        // If up_down control signal is high, increment the counter
        if (up_down) begin
            count <= count + 1;
        end 
        // If up_down control signal is low, decrement the counter
        else if (~up_down) begin
            // Ensure the counter value does not go below zero
            if (count > 16'd0) begin
                count <= count - 1;
            end
        end
    end
end

endmodule