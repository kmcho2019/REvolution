module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    q <= ~r ? d : 1'b0;
end

endmodule