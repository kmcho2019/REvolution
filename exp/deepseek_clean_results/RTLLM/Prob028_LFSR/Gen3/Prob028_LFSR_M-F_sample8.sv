module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to all zeros
    end
    else begin
        // Shift left and insert XNOR feedback at LSB
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule