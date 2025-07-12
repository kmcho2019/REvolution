module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L || E) begin  // Only update when needed
        Q <= L ? R : w; // Simplified mux when enabled
    end
    // Implicit else retains previous value (no power consumption)
end

endmodule