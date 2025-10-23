module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        q <= ({16{byteena[1]}} & {d[15:8], 8'b0} | {16{~byteena[1]}} & q) & 16'h00FF  // update upper byte selectively
           | ({16{byteena[0]}} & {8'b0, d[7:0]} | {16{~byteena[0]}} & q) & 16'hFF00;  // update lower byte selectively
    end
end

endmodule