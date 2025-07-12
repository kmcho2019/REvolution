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

// Combined enable for clock gating
assign clk_en = L | E;

// Single 3:1 mux implementation
assign next_Q = (L) ? R : 
                (E) ? w : Q;

// Clock-gated flip-flop
always @(posedge clk) begin
    if (clk_en) begin
        Q <= next_Q;
    end
end

endmodule