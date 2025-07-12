module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

always @(*) begin
    reg feedback;
    feedback = ~(out[3] ^ out[2]);
    out = {out[2:0], feedback};
end

always @ (posedge clk) begin
    if (rst) out <= 4'd0; // Initialize with zero for a known state after reset
    else out <= {out[2:0], ~(out[3] ^ out[2])};
end

endmodule