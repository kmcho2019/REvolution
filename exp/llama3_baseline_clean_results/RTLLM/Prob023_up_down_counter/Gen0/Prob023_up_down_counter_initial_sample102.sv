module up_down_counter(
    input clk,            // Clock signal
    input reset,          // Reset signal
    input up_down,        // Control signal to determine counting direction
    output [15:0] count   // 16-bit output representing the current counter value
);

reg [15:0] counter;      // reg variable to hold the counter value

always @(posedge clk) begin
    if (reset) begin     // If reset signal is active, reset the counter to zero
        counter <= 16'd0;
    end else begin
        if (up_down) begin // If up_down is high, increment the counter
            counter <= counter + 16'd1;
        end else begin     // If up_down is low, decrement the counter
            counter <= counter - 16'd1;
        end
    end
end

assign count = counter;  // Assign the counter value to the output port

endmodule