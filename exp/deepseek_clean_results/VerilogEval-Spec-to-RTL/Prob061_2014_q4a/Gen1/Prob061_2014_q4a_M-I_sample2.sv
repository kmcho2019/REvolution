module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_enable = L || E;  // Clock gating condition

always @(posedge clk) begin
    if (clk_enable) begin  // Only update when needed
        if (L) begin
            Q <= R;  // Parallel load
        end
        else begin
            Q <= w;  // Shift operation (E must be asserted)
        end
    end
    // Else maintain current value (implicit)
end

endmodule