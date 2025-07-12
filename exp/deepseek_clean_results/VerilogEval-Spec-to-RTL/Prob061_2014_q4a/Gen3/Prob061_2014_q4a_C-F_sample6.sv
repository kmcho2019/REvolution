module TopModule (
    input clk, w, R, E, L,
    output reg Q
);

always @(posedge clk) begin
    if (L) Q <= R;       // Parallel load has priority
    else if (E) Q <= w;  // Shift when enabled
end

endmodule