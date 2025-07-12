module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

wire Q_next = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    if (Q_next != Q)
        Q <= Q_next;
end

endmodule