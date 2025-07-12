module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg Q_next;

assign Q_next = (L)? R : (E)? w : Q;

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule