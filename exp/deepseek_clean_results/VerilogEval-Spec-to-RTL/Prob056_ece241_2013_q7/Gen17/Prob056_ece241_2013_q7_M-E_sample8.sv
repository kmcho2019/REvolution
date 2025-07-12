module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire [1:0] select = {j, k};
wire Q_next;

// 4:1 mux implementing JK truth table
assign Q_next = (select == 2'b00) ? Q :
                (select == 2'b01) ? 1'b0 :
                (select == 2'b10) ? 1'b1 :
                ~Q;  // select == 2'b11

reg Q_reg;
always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule