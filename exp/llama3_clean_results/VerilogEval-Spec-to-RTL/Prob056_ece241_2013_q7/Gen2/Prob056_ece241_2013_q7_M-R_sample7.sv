module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

always @(*) begin
    if (j == 0 && k == 0) begin
        Q_next = Q; // Qold
    end else if (j == 0 && k == 1) begin
        Q_next = 0;
    end else if (j == 1 && k == 0) begin
        Q_next = 1;
    end else if (j == 1 && k == 1) begin
        Q_next = ~Q; // ~Qold
    end
end

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule