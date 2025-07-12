module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state (0 to 7)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset counter to 0 when reset is high
        out <= 8'b0000_0001; // Initialize out directly
    end else begin
        counter <= counter + 1; // Increment counter on each clock pulse
        if (counter == 7) begin
            counter <= 0; // Wrap counter around to 0 after reaching 7
        end
    end
end

// Use the counter value to set the corresponding bit high in the output
always @(*) begin
    out = 8'b0; // Reset all bits to 0
    out[counter] = 1'b1; // Set the bit corresponding to the counter value to 1
end

endmodule