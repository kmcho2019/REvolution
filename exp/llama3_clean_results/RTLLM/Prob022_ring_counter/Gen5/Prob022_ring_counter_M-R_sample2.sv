module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // Counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0 when reset is high
        out <= 8'b0000_0001; // Initialize out directly
    end else begin
        // Increment the counter and wrap around to 0 when it reaches 7
        counter <= (counter == 7)? 0 : counter + 1;
    end
end

// Directly assign the output vector based on the counter value
assign out = (1 << counter);

endmodule