module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100
);

always @(posedge clk) begin
    q <= a ? q : 
         (q == 3'b110) ? 3'b000 : 
         q + 1;
end

endmodule