module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    // Initialize the output to its starting state when reset is high
    always @ (posedge reset) begin
        out <= 8'b0000_0001;
    end

    // On each rising edge of the clock signal, shift the '1' bit to the next position
    always @ (posedge clk) begin
        if (~reset) begin
            // If the '1' bit is at the most significant bit, wrap it around to the least significant bit
            if (out == 8'b1000_0000) begin
                out <= 8'b0000_0001;
            end else begin
                // Otherwise, shift the '1' bit to the next position
                out <= {out[6:0], out[7]};
            end
        end
    end

endmodule