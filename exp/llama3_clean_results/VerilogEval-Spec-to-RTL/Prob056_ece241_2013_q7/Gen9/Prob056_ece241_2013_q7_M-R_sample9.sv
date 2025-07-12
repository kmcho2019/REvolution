module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

assign Q_next = (j == 1 && k == 1)? ~Q :
                 (j == 1 && k == 0)? 1 :
                 (j == 0 && k == 1)? 0 : Q;

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule