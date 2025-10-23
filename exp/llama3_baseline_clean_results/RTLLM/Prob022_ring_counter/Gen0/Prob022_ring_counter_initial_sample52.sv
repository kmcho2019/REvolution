module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to the starting state (LSB set to 1)
    end else begin
        // Shift the '1' to the next bit position in the output
        if (out == 8'b1000_0000) begin
            // If the MSB is set, wrap around to the LSB
            out <= 8'b0000_0001;
        end else begin
            // Shift the '1' to the next bit position
            out <= {out[6:0], out[7]};
        end
    end
end

endmodule