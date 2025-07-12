module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

always @(*) begin
    if (j == 1'b0 && k == 1'b0) begin
        Q_next = Q;
    end else if (j == 1'b0 && k == 1'b1) begin
        Q_next = 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        Q_next = 1'b1;
    end else begin
        Q_next = ~Q;
    end
end

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule