module ring_counter(
    input clk, 
    input reset, 
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its initial state
        out <= 8'b0000_0001;
    end else begin
        // Shift the current state one bit to the right and fill the MSB with 0
        // However, to implement a ring counter, we need to wrap around, so we use a different approach
        // We set the next bit in sequence high by shifting the current state left and then setting the LSB high if the MSB is 1
        // This effectively moves the '1' to the next position in the sequence, wrapping around if necessary
        if (out[7]) begin
            out <= 8'b0000_0001;
        end else begin
            out <= {out[6:0], 1'b0} | 8'b0000_0001;
        end
    end
end

endmodule