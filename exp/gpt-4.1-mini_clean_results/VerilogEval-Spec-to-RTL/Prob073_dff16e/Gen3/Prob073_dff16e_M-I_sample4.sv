module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Create mask for upper and lower bytes based on byteena
        // If byteena bit is 1, select d byte; else keep q byte
        q <= ({16{byteena[1]}} & {d[15:8], 8'b0}) |
             ({16{byteena[0]}} & {8'b0, d[7:0]}) |
             ({16{~byteena[1] & ~byteena[0]}} & q) |
             ({16{byteena[1] & ~byteena[0]}} & {d[15:8], q[7:0]}) |
             ({16{~byteena[1] & byteena[0]}} & {q[15:8], d[7:0]});
    end
end

endmodule