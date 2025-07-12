module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the shift register to its starting state
        out <= 8'b0000_0001;
    end else begin
        // Shift the register one bit to the right on each clock cycle
        out <= {out[6:0], out[7]};
    end
end

endmodule