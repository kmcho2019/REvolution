module up_down_counter(
    input           clk,       // Clock signal
    input           reset,     // Reset signal
    input           up_down,   // Control signal for counting direction
    output reg [15:0] count    // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to zero
        count <= 16'd0;
    end else if (up_down) begin
        // Increment the counter
        count <= count + 1;
    end else begin
        // Decrement the counter
        count <= count - 1;
    end
end

endmodule