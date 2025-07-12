module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire load_data = L & R;
wire shift_data = E & w & ~L;
wire hold_data = Q & ~L & ~E;
wire next_Q = load_data | shift_data | hold_data;

// Clock gating logic
wire clk_en = L | E;
wire gated_clk = clk & clk_en;

always @(posedge gated_clk) begin
    Q <= next_Q;
end

endmodule