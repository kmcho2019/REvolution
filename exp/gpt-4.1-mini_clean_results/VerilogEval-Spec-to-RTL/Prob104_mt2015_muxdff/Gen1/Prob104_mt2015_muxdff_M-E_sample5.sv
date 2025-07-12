module mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module d_flip_flop (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

wire mux_out;

mux2to1 mux (
    .sel(L),
    .in0(q_in),
    .in1(r_in),
    .out(mux_out)
);

d_flip_flop dff (
    .clk(clk),
    .d(mux_out),
    .q(Q)
);

endmodule