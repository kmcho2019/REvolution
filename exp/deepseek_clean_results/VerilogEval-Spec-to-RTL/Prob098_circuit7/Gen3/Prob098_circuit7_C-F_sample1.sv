module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    q <= a ? 0 : 1;
end

endmodule