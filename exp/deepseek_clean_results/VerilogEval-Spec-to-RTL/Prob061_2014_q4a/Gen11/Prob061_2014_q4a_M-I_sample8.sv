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
        Q <= R;       // Highest priority: Load
    end
    else if (E) begin
        Q <= w;       // Shift when enabled
    end
    // else hold (implicit)
end

endmodule