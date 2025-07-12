module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg clk_enable;

always @(posedge clk) begin
    if (clk_enable) begin
        if (L) begin
            // Load R into Q
            Q <= R;
        end else if (E) begin
            // Shift w into Q
            Q <= w;
        end
    end
end

assign clk_enable = L || (E && (w !== Q));

endmodule