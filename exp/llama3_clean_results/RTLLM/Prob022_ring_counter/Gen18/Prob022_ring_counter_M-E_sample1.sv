module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to cycle through 0 to 7

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000; // Reset counter to 0
    end else begin
        // Increment counter, wrapping around from 7 to 0
        counter <= (counter == 3'b111) ? 3'b000 : counter + 1;
    end
end

always @(*) begin
    // Initialize output to all zeros
    out = 8'b0000_0000;
    // Set the bit corresponding to the counter's value to '1'
    out[counter] = 1'b1;
end

endmodule