module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        // Calculate the feedback signal by XORing the MSB and the second MSB
        // Then insert this value as the new LSB, shifting the other bits left
        out <= {out[2:0], out[3] ^ out[2]};
    end
end

endmodule