module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

always @(posedge clk) begin
    if (j == 1'b0 && k == 1'b0) begin
        Q_reg <= Q_reg;  // Hold state
    end
    else if (j == 1'b0 && k == 1'b1) begin
        Q_reg <= 1'b0;   // Reset
    end
    else if (j == 1'b1 && k == 1'b0) begin
        Q_reg <= 1'b1;   // Set
    end
    else begin
        Q_reg <= ~Q_reg; // Toggle
    end
end

assign Q = Q_reg;

endmodule