module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    q <= shift_ena ? {q[2:0], data} : 
         count_ena ? q - 1'b1 : 
         q;
end

endmodule