module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    wire mux_out;

    // 2:1 multiplexer module
    Mux2to1 mux_inst (
        .sel(L),
        .d0(q_in),
        .d1(r_in),
        .y(mux_out)
    );

    // D flip-flop module
    DFF dff_inst (
        .clk(clk),
        .d(mux_out),
        .q(Q)
    );

endmodule

// 2:1 Mux module
module Mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

// D flip-flop module with positive-edge clock and non-blocking assignment
module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule