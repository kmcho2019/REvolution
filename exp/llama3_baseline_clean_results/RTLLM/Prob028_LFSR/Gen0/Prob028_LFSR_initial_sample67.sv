module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] out;

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the LFSR to zero when rst is high
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit and inverting the result
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left and insert feedback at the LSB
    end
end

endmodule