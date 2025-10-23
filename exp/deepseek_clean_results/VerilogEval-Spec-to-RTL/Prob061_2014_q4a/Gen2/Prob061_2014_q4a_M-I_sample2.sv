module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk = clk & (L | E);  // Clock gating when neither L nor E is active

always @(posedge gated_clk) begin
    if (L) begin
        Q <= R;  // Parallel load
    end
    else begin  // E must be active if we're here (due to clock gating)
        Q <= w;  // Shift operation
    end
end

endmodule