module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) Q <= R;      // Highest priority: load
    else if (E) Q <= w; // Shift when enabled
    // Implicit else maintains state
end

endmodule