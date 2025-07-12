module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= R;         // Highest priority: load
    end
    else if (E) begin
        Q <= w;         // Shift when enabled
    end
    // else maintain state (implicit, helps with clock gating)
end

endmodule