module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Q_next;

always @(j, k, Q) begin
    case ({j, k})
        2'b00: Q_next = Q;
        2'b01: Q_next = 1'b0;
        2'b10: Q_next = 1'b1;
        2'b11: Q_next = ~Q;
    endcase
end

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule