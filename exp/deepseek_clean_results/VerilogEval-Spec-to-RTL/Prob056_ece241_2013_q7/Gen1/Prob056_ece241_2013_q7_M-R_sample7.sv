module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire next_Q;

// Combinational logic for next state
assign next_Q = (j & k) ? ~Q_reg :
                (j & ~k) ? 1'b1 :
                (~j & k) ? 1'b0 :
                Q_reg;

// Sequential element (D flip-flop)
always @(posedge clk) begin
    Q_reg <= next_Q;
end

assign Q = Q_reg;

endmodule