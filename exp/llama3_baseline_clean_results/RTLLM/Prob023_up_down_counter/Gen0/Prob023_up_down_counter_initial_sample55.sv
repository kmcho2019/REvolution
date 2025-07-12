module up_down_counter(
    input clk,           // Clock signal
    input reset,         // Reset signal
    input up_down,       // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'd0;  // Reset the counter to zero when reset is active
    end else begin
        if (up_down) begin
            count <= count + 1;  // Increment the counter when up_down is high
        end else begin
            count <= count - 1;  // Decrement the counter when up_down is low
        end
    end
end

endmodule