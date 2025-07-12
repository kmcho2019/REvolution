module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment count directly
            count <= count + 1;
        end else begin
            // Decrement count directly, handling wrap-around
            count <= count - 1;
        end
    end
end

endmodule