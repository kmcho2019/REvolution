module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Next state logic:
// Case 1: J != K -> Q takes J's value
// Case 2: J == K == 1 -> toggle
// Case 3: J == K == 0 -> maintain state
wire Q_next = (j ^ k) ? j : (j & k) ? ~Q_reg : Q_reg;

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule