module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

wire next_Q;

assign next_Q = L ? R : (E ? w : Q);

dff dff_inst (
    .clk(clk),
    .d(next_Q),
    .q(Q)
);

endmodule

module dff (
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule