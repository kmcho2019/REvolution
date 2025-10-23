module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Reset to all zeros
    end
    else begin
        // Simplified: Shift left and insert XOR of bits 3 and 2 at LSB
        out <= {out[2:0], out[3] ^ out[2]};
    end
end

endmodule