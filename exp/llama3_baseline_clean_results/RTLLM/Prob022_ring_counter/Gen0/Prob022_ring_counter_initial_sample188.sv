module ring_counter(
    input clk, 
    input reset, 
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current position in the sequence

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize the counter to its starting state
        counter <= 3'b000; // Reset the position counter
    end else begin
        out <= 8'b0000_0001 << counter; // Shift the '1' to the next bit
        counter <= counter + 1; // Increment the position counter
        if (counter == 3'b111) begin // Wrap around to the LSB after reaching the MSB
            counter <= 3'b000;
        end
    end
end

endmodule