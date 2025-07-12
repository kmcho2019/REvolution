module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;
wire [1:0] jk = {j, k};

always @(posedge clk) begin
    case (jk)
        2'b00: Q_reg <= Q_reg;    // Hold state
        2'b01: Q_reg <= 1'b0;     // Reset
        2'b10: Q_reg <= 1'b1;     // Set
        2'b11: Q_reg <= ~Q_reg;   // Toggle
    endcase
end

assign Q = Q_reg;

endmodule