module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 0
);

reg Q_next;

always @(posedge clk) begin
    Q <= Q_next;
end

always @(*) begin
    case({j, k})
        2'b00: Q_next = Q; // No change
        2'b01: Q_next = 1'b0; // Reset
        2'b10: Q_next = 1'b1; // Set
        2'b11: Q_next = ~Q; // Toggle
    endcase
end

endmodule