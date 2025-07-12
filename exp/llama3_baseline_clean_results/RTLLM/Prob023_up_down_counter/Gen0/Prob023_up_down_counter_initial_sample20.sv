module up_down_counter(
    input clk,  // Clock signal
    input reset,  // Reset signal
    input up_down,  // Control signal for counting direction
    output reg [15:0] count  // 16-bit output for the counter value
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to zero when the reset signal is active
        count <= 16'd0;
    end else begin
        // Increment the counter if up_down is high
        if (up_down) begin
            count <= count + 1;
        end 
        // Decrement the counter if up_down is low
        else begin
            count <= count - 1;
        end
    end
end

endmodule