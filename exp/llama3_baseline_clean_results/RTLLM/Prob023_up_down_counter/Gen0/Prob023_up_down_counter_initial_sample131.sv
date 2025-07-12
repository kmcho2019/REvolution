module up_down_counter(
    input clk,     // Clock signal
    input reset,   // Reset signal
    input up_down, // Control signal for counting direction
    output [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] counter; // Internal reg to store the counter value

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset is active
        counter <= 16'd0;
    end else if (up_down) begin
        // Increment the counter when up_down is high
        counter <= counter + 1;
    end else begin
        // Decrement the counter when up_down is low
        counter <= counter - 1;
    end
end

assign count = counter; // Assign the internal counter value to the output port

endmodule