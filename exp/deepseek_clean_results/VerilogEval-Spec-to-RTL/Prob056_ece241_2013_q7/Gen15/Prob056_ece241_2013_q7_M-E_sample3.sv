module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire [1:0] select = {j, k};

always @(posedge clk) begin
    case (select)
        2'b00: Q_reg <= Q_reg;      // Hold
        2'b01: Q_reg <= 1'b0;      // Reset
        2'b10: Q_reg <= 1'b1;      // Set
        2'b11: Q_reg <= ~Q_reg;    // Toggle
    endcase
end

assign Q = Q_reg;

endmodule