module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the output vector with the least significant bit set to 1
        out <= 8'b0000_0001;
    end else begin
        // Shift the contents of the output vector one position to the right
        // and wrap the most significant bit back around to the least significant bit
        out <= {out[6:0], out[7]};
    end
end

endmodule