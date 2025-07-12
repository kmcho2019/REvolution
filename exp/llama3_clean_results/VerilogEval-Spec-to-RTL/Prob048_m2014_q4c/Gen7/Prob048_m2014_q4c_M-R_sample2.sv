module TopModule(
    input clk,
    input d,
    input r,
    output reg q = 1'b0
);

always @(posedge clk) begin
    q <= r? 1'b0 : d;
end

endmodule