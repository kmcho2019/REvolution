module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

wire next_Q = L ? R : (E ? w : Q);
wire clk_en = L | E;  // Clock gating when neither load nor shift

dff_en dff_inst (
    .clk(clk),
    .en(clk_en),
    .d(next_Q),
    .q(Q)
);

endmodule

module dff_en (
    input clk,
    input en,
    input d,
    output reg q
);
always @(posedge clk) begin
    if (en) q <= d;
end
endmodule