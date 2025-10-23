module ring_counter(
    input clk, 
    input reset, 
    output reg [7:0] out
);

reg [2:0] state; // State variable to track the current bit position (0 to 7)

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset state to 0 (LSB)
        out <= 8'b0000_0001; // Reset output to initial state
    end else begin
        if (state == 7) begin // If at MSB, wrap around to LSB
            state <= 0;
            out <= 8'b0000_0001;
        end else begin // Otherwise, shift to the next bit
            state <= state + 1;
            out <= (1 << state); // Set the bit at the current state position high
        end
    end
end

endmodule