module ring_counter (
    input           clk,    // Clock signal
    input           reset,  // Reset signal
    output reg [7:0] out     // 8-bit output
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its starting state
        out <= 8'b0000_0001;
    end else begin
        // Shift the '1' to the next bit in the sequence
        // If the MSB is set, wrap around to the LSB
        if (out == 8'b1000_0000) begin
            out <= 8'b0000_0001;
        end else begin
            // Use bitwise operations to shift the '1' to the next position
            out <= {out[6:0], out[7]};
        end
    end
end

endmodule