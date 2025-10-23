module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to track the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000; // Reset counter to 0
        out <= 8'b0000_0001; // Initialize out to its starting state
    end else begin
        counter <= counter + 1; // Increment counter
        if (counter == 3'b111) begin
            counter <= 3'b000; // Wrap around to 0 after reaching 7
        end
        out <= 1 << counter; // Set the bit corresponding to the counter value
    end
end

endmodule