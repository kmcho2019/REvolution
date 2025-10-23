module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule