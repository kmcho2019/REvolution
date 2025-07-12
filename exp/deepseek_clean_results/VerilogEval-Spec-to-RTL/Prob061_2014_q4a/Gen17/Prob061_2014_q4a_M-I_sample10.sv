module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_en = E | L;  // Clock enable when either shifting or loading

always @(posedge clk) begin
    if (clk_en) begin
        Q <= L ? R : w;  // Simplified mux when clock is enabled
    end
    // Else Q holds its value (implicit)
end

endmodule