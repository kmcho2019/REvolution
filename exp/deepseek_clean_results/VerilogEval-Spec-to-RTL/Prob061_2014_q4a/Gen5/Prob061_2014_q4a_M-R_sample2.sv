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
        Q <= R;  // Load has highest priority
    end
    else if (E) begin
        Q <= w;  // Shift if enabled (but not loading)
    end
    // else retain current value (implicit)
end

endmodule