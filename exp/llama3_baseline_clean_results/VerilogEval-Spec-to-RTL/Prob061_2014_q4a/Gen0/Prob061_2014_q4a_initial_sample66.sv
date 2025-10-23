module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg Q_reg; // internal register to store the value of Q
assign Q = Q_reg; // assign the internal register to the output Q

// select the input to the flip-flop based on L
wire D;
assign D = L ? R : (E ? w : Q_reg);

// D flip-flop
always @(posedge clk) begin
    Q_reg <= D;
end

endmodule