module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

always @(posedge clk) begin
    out <= rst ? 4'b0001 : {out[2:0], out[3] ~^ out[2]};
end

endmodule