module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire next_Q;
wire clk_en;

// Clock gating when J=K=0 to reduce power
assign clk_en = (j | k);

// Combinational next state logic using case statement
always @(*) begin
    case ({j, k})
        2'b00: next_Q = Q_reg;
        2'b01: next_Q = 1'b0;
        2'b10: next_Q = 1'b1;
        2'b11: next_Q = ~Q_reg;
    endcase
end

// Sequential element with clock gating
always @(posedge clk) begin
    if (clk_en) begin
        Q_reg <= next_Q;
    end
end

assign Q = Q_reg;

endmodule