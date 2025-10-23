module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire clk_posedge = clk & ~$past(clk);  // Detect positive edge
wire Q_next = (j ^ k) ? j : (j & k) ^ Q;
reg Q_reg;

always @* begin
    if (clk_posedge)
        Q_reg = Q_next;
    else
        Q_reg = Q;  // Maintain state when not on clock edge
end

assign Q = Q_reg;

endmodule