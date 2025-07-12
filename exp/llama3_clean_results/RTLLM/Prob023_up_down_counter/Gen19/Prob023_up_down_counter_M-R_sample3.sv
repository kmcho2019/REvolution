module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (up_down) begin
        // Increment count, wrapping around at 65535
        count <= (count == 16'd65535) ? 16'd0 : count + 1;
    end else begin
        // Decrement count, wrapping around at 0
        count <= (count == 16'd0) ? 16'd65535 : count - 1;
    end
end

endmodule