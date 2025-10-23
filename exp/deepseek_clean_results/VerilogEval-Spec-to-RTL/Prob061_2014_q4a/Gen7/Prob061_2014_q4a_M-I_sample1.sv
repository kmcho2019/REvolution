module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_enable = L | E;  // Clock enable when either load or shift is active

always @(posedge clk) begin
    if (clk_enable) begin
        if (L) begin
            Q <= R;  // Highest priority: load
        end
        else begin  // E must be true here
            Q <= w;  // Shift operation
        end
    end
end

endmodule