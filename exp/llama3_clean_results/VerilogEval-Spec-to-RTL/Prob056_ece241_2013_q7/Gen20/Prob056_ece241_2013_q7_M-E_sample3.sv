module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

always @(*) begin
    // Compute next state of Q
    Q_next = (~j & ~k) ? Q : (~j & k) ? 1'b0 : (j & ~k) ? 1'b1 : ~Q;
end

always @(posedge clk) begin
    // Update Q on positive clock edge
    Q <= Q_next;
end

endmodule