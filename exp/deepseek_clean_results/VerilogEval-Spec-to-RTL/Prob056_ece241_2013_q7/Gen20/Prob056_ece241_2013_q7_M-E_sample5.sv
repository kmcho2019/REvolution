module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

// Mux-based next state logic
wire [1:0] select = {j, k};
wire Q_next = (select == 2'b00) ? Q_reg :
              (select == 2'b01) ? 1'b0 :
              (select == 2'b10) ? 1'b1 :
              ~Q_reg;  // select == 2'b11

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule