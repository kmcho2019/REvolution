module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

wire mux_out;
wire ff_enable;

// Control unit
assign ff_enable = E | L;
assign mux_out = L ? R : w;

// Storage element with explicit enable
dff_with_en u_dff (
    .clk(clk),
    .d(mux_out),
    .en(ff_enable),
    .q(Q)
);

endmodule

module dff_with_en (
    input clk,
    input d,
    input en,
    output reg q
);
always @(posedge clk) begin
    if (en) q <= d;
end
endmodule