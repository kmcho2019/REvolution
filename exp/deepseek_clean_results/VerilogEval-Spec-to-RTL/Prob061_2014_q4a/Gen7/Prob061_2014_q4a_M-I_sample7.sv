module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L)       Q <= R;    // Load has highest priority
    else if (E)  Q <= w;    // Shift when enabled
    // else Q holds its value (implicit)
end

endmodule