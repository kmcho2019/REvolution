module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg Q_reg;

always @(posedge clk) begin
    case ({L, E})
        2'b10, 2'b11: Q_reg <= R;  // Load has priority
        2'b01:        Q_reg <= w;  // Shift enabled
        default:       Q_reg <= Q_reg;  // Hold
    endcase
end

assign Q = Q_reg;

endmodule