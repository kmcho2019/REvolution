module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_Q;
wire clk_en;

// Reordered mux priority - E first (assuming shifts are more frequent than loads)
assign next_Q = E ? w : (L ? R : Q);

// Clock gating - only enable clock when needed
assign clk_en = E | L;

always @(posedge clk) begin
    if (clk_en) begin
        Q <= next_Q;
    end
end

endmodule