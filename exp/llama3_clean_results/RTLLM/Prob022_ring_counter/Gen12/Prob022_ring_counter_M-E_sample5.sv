module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize out to starting state when reset is high
    end else begin
        out <= {out[6:0], out[7]}; // Shift out one bit to the right and wrap around
    end
end

endmodule