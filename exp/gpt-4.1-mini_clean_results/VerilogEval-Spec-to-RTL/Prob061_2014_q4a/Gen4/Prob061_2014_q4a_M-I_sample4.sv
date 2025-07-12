module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clk_en;
reg next_Q;

// Enable clock gating when load or shift is active
assign clk_en = L | E;

// Gated clock generation
wire gated_clk = clk & clk_en;

always @(*) begin
    if (L)
        next_Q = R;
    else if (E)
        next_Q = w;
    else
        next_Q = Q;
end

// Use gated clock to reduce switching when not shifting or loading
always @(posedge gated_clk or negedge clk_en) begin
    if (!clk_en)
        Q <= Q; // hold state without toggling
    else
        Q <= next_Q;
end

endmodule