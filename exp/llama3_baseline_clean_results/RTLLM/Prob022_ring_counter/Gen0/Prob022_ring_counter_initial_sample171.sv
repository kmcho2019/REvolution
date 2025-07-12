module ring_counter(
    input clk,  // Clock signal
    input reset,  // Reset signal
    output reg [7:0] out  // 8-bit output representing the current state
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to its starting state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Perform a left shift of the current state and add the MSB to the LSB to create the cyclic sequence
        out <= {out[6:0], out[7]};
    end
end

endmodule