module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to track the state (0 to 7)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset counter to 0
    end else begin
        counter <= (counter == 7) ? 0 : counter + 1; // Increment or wrap around
    end
end

always @(*) begin
    out = 8'b0; // Clear all bits
    out[counter] = 1'b1; // Set the bit corresponding to the counter value high
end

endmodule