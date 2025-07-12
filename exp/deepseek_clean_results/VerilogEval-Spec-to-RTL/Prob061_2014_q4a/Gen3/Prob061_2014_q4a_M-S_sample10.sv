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
        Q <= R;  // Load takes priority
    end
    else if (E) begin
        Q <= w;  // Shift when enabled
    end
    // Else maintain current value
end

endmodule