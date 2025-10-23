module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

always @(*) begin
    // Characteristic equation for JK flip-flop
    Q_next = (j & ~Q) | (~k & Q);
end

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule