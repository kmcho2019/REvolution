module up_down_counter(
    input clk, // Clock signal
    input reset, // Reset signal
    input up_down, // Control signal for counting direction
    output reg [15:0] count // 16-bit output for current counter value
);

always @ (posedge clk) begin
    if (reset) begin // If reset is active, reset the counter to zero
        count <= 16'd0;
    end else begin
        if (up_down) begin // If up_down is high, increment the counter
            count <= count + 1;
        end else begin // If up_down is low, decrement the counter
            count <= count - 1;
        end
    end
end

endmodule