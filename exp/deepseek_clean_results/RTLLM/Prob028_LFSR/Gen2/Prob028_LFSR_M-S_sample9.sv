module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Reset to non-zero state (better for LFSR operation)
    end
    else begin
        out <= {out[2:0], out[3] ^ out[2]};
    end
end

endmodule