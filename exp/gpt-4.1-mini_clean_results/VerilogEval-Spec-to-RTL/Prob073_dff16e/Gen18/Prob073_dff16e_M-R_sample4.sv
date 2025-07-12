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
        q <= (q & ~{byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],
                    byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0]})
             | (d & { {8{byteena[1]}}, {8{byteena[0]}} });
    end
end

endmodule