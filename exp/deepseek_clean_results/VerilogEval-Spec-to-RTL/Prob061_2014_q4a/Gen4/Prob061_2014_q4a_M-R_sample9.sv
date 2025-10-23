module TopModule (
    input clk, w, R, E, L,
    output Q
);

wire next_Q = L ? R : (E ? w : Q);
dff dff_inst(.clk(clk), .d(next_Q), .q(Q));

endmodule

module dff (
    input clk, d,
    output reg q
);
always @(posedge clk) q <= d;
endmodule