module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0
    end else begin
        // Increment the counter with each clock cycle, wrapping around if necessary
        counter <= (counter == 7)? 0 : counter + 1;
    end
end

// Use an assign statement to generate the output based on the counter's current value
assign out = (1 << counter);

endmodule