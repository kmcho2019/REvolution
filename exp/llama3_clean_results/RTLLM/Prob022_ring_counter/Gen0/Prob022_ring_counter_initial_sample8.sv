module ring_counter(
    input clk, 
    input reset, 
    output reg [7:0] out
);

always @(*) begin
    if (reset) begin
        // Reset the counter to its initial state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Handle clock-driven state transition
        if (clk) begin
            // This block will be executed on every rising edge of the clock
            // Shift the 1 to the next bit in the sequence, wrapping around to the LSB after the MSB
            out <= {out[6:0], out[7]};
        end
    end
end

endmodule