module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire enable = L || E;
wire D = L ? R : w;
wire gated_clk = enable ? clk : Q;  // Simple clock gating (conceptual)

always @(posedge gated_clk) begin
    if (enable) begin
        Q <= D;
    end
    // Note: Actual implementation would use proper clock gating cells
    // This is a conceptual representation of the optimization
end

endmodule