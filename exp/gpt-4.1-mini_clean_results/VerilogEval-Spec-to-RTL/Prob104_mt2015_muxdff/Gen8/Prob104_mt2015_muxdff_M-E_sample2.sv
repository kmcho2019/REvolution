// 2:1 multiplexer submodule
module Mux2to1 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// Positive edge-triggered D flip-flop with synchronous clock
module DFlipFlop (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// TopModule combines Mux2to1 and DFlipFlop
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    wire mux_out;

    // Instantiate mux: select r_in if L=1, else q_in
    Mux2to1 u_mux (
        .sel(L),
        .in0(q_in),
        .in1(r_in),
        .out(mux_out)
    );

    // Instantiate D flip-flop: latch mux_out on rising clk
    DFlipFlop u_dff (
        .clk(clk),
        .d(mux_out),
        .q(Q)
    );

endmodule