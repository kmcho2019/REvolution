module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the output to its starting state when reset is high
always @(*) begin
    if (reset) begin
        out <= 8'b0000_0001;
    end
end

// State transition on each rising edge of the clock signal
always @(posedge clk) begin
    if (!reset) begin
        out <= {out[6:0], out[7]}; // Shift the bits one position to the right and move the MSB to the LSB
    end else begin
        out <= 8'b0000_0001; // Reset the counter when reset is high
    end
end

endmodule