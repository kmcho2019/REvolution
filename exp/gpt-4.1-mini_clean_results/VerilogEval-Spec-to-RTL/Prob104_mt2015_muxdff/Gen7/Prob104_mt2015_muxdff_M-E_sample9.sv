module mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
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

module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

wire mux_out;

mux2to1 mux_inst (
    .sel(L),
    .d0(q_in),
    .d1(r_in),
    .y(mux_out)
);

dff dff_inst (
    .clk(clk),
    .d(mux_out),
    .q(Q)
);

endmodule