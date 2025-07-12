module up_down_counter(
    input clk,          // Clock signal
    input reset,        // Reset signal
    input up_down,      // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to 0 when the reset signal is active
        count <= 16'd0;
    end else if (up_down) begin
        // Increment the counter when up_down is 1
        if (count == 16'd65535) begin
            count <= 16'd0;  // Handle overflow by wrapping around to 0
        end else begin
            count <= count + 1'b1;
        end
    end else begin
        // Decrement the counter when up_down is 0
        if (count == 16'd0) begin
            count <= 16'd65535;  // Handle underflow by wrapping around to 65535
        end else begin
            count <= count - 1'b1;
        end
    end
end

endmodule