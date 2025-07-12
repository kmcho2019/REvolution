module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    q <= !resetn ? 16'b0 : 
         (d & {16{byteena[1]}} & 16'hFF00) | 
         (d & {16{byteena[0]}} & 16'h00FF) | 
         (q & ~({16{byteena[1]}} & 16'hFF00) & ~({16{byteena[0]}} & 16'h00FF));
end

endmodule