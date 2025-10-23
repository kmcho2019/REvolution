module up_down_counter(
    input clk,  // Clock signal
    input reset,  // Reset signal
    input up_down,  // Control signal for counting direction
    output reg [15:0] count  // 16-bit output for counter value
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset counter to zero when reset signal is active
        count <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment counter when up_down is high
            count <= count + 1;
        end else begin
            // Decrement counter when up_down is low
            count <= count - 1;
        end
    end
end

endmodule