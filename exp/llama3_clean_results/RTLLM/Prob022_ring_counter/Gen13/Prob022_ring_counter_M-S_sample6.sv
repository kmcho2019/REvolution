module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Update out to the next state in the cyclic sequence
        out <= {out[6:0], out[7]}; // Shift left and wrap around
    end
end

endmodule