module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        out <= 8'b1; // Initialize out with the LSB set to 1
    end else begin
        counter <= (counter == 7)? 0 : counter + 1;
        // Clear all bits in out
        out <= 0;
        // Set the bit corresponding to the counter value to 1
        out[counter] <= 1;
    end
end

endmodule