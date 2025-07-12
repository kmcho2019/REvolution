module up_down_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    input up_down,  // Control signal for counting direction
    output [15:0] count  // 16-bit counter output
);

reg [15:0] counter;  // 16-bit register to store the counter value

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset signal is active
        counter <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment the counter when up_down is high
            counter <= counter + 1;
        end else begin
            // Decrement the counter when up_down is low
            counter <= counter - 1;
        end
    end
end

assign count = counter;  // Assign the current counter value to the output port

endmodule