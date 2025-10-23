module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize the counter to its starting state
            out <= 8'b0000_0001;
        end else begin
            // Shift the '1' to the next bit in the sequence
            if (out == 8'b1000_0000) begin
                // Wrap around to the LSB after reaching the MSB
                out <= 8'b0000_0001;
            end else begin
                // Shift the '1' to the next bit
                out <= {out[6:0], out[7]};
            end
        end
    end

endmodule