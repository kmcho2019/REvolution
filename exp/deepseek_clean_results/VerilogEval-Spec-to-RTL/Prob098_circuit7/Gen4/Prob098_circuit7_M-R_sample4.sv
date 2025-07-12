module TopModule (
    input clk,
    input a,
    output reg q
);

wire d;
assign d = a ? 0 : 1;

always @(posedge clk) begin
    q <= d;
end

endmodule