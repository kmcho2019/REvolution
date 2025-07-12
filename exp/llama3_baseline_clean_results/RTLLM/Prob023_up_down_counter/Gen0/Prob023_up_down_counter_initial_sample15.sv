module up_down_counter(
    input clk,       // Clock signal
    input reset,     // Reset signal
    input up_down,   // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;  // Reset counter to zero
    end else begin
        if (up_down) begin
            count <= count + 1;  // Increment counter
        end else begin
            count <= count - 1;  // Decrement counter
        end
    end
end

endmodule