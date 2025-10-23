module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the output to the starting state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Shift the bits one position to the right and feed the MSB back to the LSB
        out <= {out[6:0], out[7]};
    end
end

endmodule