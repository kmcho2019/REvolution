module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        q <= (byteena[1] ? {d[15:8], 8'b0} : 16'b0 & 16'hFF00) |
             (byteena[0] ? {8'b0, d[7:0]} : 16'b0 & 16'h00FF) |
             (q & ~((byteena[1] ? 16'hFF00 : 16'h0000) | (byteena[0] ? 16'h00FF : 16'h0000)));
    end
end

endmodule