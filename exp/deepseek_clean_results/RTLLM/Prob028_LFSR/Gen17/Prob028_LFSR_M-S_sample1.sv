module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Non-zero initial state
    end
    else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};  // Shift left + XNOR feedback
    end
end

endmodule