module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg Q_next;

always @(*) begin
    if (L) begin
        Q_next = R;
    end else begin
        Q_next = E? w : Q;
    end
end

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule