module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    // Initialize the output to its starting state
    initial begin
        out = 8'b0000_0001;
    end

    // On each rising edge of the clock signal, shift the 1 one position to the right
    always @ (posedge clk) begin
        if (reset) begin
            // If reset is high, reset the counter to its starting state
            out <= 8'b0000_0001;
        end else begin
            // Shift the 1 one position to the right, wrapping around to the MSB when necessary
            out <= {out[6:0], out[7]};
        end
    end

endmodule