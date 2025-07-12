module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'd0;  // Initialize to zero when reset is high
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Shift left and insert feedback
    end
end

endmodule