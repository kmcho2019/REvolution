module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0
        out <= 8'b0000_0001; // Initialize out to its starting state
    end else begin
        // Increment the counter with each clock cycle
        if (counter == 7) begin
            counter <= 0; // Wrap around to 0 when the counter reaches its maximum value
        end else begin
            counter <= counter + 1;
        end
        
        // Update the out register based on the counter's state
        out <= 1 << counter;
    end
end

endmodule