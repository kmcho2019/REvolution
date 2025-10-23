module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire [1:0] select = {j, k};
wire Q_next;

assign Q_next = (select == 2'b00) ? Q :    // Hold state
                (select == 2'b01) ? 1'b0 : // Reset
                (select == 2'b10) ? 1'b1 : // Set
                ~Q;                        // Toggle

reg Q_reg;
always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule