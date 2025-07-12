module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Qnext;

assign Qnext = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= Qnext;
end

endmodule