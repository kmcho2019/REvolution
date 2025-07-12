module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

assign Q_next = (j == 1'b0) ? (k == 1'b0) ? Q : 1'b0 : (k == 1'b0) ? 1'b1 : ~Q;

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule