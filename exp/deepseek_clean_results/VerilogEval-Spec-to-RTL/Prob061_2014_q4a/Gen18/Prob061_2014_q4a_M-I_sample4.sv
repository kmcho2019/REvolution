module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_enable = L | E;  // Clock gating control

always @(posedge clk) begin
    if (clk_enable) begin
        Q <= L ? R : w;    // Load has priority, then shift
    end
    // Implicit else: hold current value (clock gated)
end

endmodule