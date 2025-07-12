module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

always @(*) begin
    if (j == 0 && k == 0)
        Q_next = Q;       // hold state
    else if (j == 0 && k == 1)
        Q_next = 1'b0;    // reset
    else if (j == 1 && k == 0)
        Q_next = 1'b1;    // set
    else // j == 1 && k == 1
        Q_next = ~Q;      // toggle
end

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule