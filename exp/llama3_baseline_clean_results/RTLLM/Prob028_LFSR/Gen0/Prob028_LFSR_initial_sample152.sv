module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        // Reset the register to zero
        out <= 4'd0;
    end else begin
        // Calculate feedback by XORing out[3] and out[2] and inverting the result
        reg [3:0] temp_out;
        temp_out = out;
        out <= {out[2:0], ~(temp_out[3] ^ temp_out[2])};
    end
end

endmodule