module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0; // Reset the LFSR to zero when rst is high
    end else begin
        out <= {out[2:0], ~(out[3] ^ out[2])}; // Shift left and insert feedback at LSB
    end
end

endmodule