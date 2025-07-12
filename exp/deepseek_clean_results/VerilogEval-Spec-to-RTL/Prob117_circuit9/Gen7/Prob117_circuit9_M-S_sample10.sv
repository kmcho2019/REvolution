module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    q <= a ? 3'b100 : q + 1;
end

endmodule