module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // Counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0 when reset is high
    end else begin
        // Increment the counter and wrap around to 0 when it reaches 7
        counter <= (counter == 7) ? 0 : counter + 1;
    end
end

// Generate the output vector based on the current state (counter value)
always @(*) begin
    out = 8'b0; // Initialize out to all zeros
    out[counter] = 1'b1; // Set the bit corresponding to the current state to 1
end

endmodule