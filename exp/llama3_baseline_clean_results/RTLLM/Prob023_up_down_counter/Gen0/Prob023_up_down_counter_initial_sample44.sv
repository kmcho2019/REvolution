module up_down_counter (
    input clk,       // 1-bit clock signal
    input reset,     // 1-bit reset signal
    input up_down,   // 1-bit control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @(posedge clk) begin
    if (reset) begin
        // If reset is high, reset the counter to zero
        count <= 16'd0;
    end else if (up_down) begin
        // If up_down is high, increment the counter
        count <= count + 1;
    end else begin
        // If up_down is low, decrement the counter
        count <= count - 1;
    end
end

endmodule