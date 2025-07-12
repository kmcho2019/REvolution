module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal to determine counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] counter;  // Internal reg to hold the counter value

always @ (posedge clk) begin
    if (reset) begin
        // If reset is active, reset the counter to zero
        counter <= 16'd0;
    end else begin
        // If up_down is high, increment the counter; otherwise, decrement it
        if (up_down) begin
            counter <= counter + 16'd1;
        end else begin
            counter <= counter - 16'd1;
        end
    end
end

// Assign the counter value to the output port
assign count = counter;

endmodule