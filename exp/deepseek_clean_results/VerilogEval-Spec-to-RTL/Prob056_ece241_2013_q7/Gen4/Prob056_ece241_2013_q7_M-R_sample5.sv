module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire Q_next;

assign Q_next = (j & k) ? ~Q :
                (j) ? 1'b1 :
                (k) ? 1'b0 :
                Q;

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule