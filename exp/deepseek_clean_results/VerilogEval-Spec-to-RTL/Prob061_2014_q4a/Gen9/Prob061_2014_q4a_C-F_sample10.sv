module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Priority: Load (L) > Shift (E) > Hold
always @(posedge clk) begin
    if (L)      Q <= R;    // Load takes highest priority
    else if (E) Q <= w;    // Shift when enabled
    // else Q maintains current value (implicit)
end

endmodule