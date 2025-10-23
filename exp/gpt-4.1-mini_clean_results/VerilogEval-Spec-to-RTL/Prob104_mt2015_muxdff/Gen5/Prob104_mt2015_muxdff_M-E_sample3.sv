module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire d;

    // 2:1 multiplexer submodule
    Mux2to1 mux_inst (
        .sel(L),
        .in0(q_in),
        .in1(r_in),
        .out(d)
    );

    // D flip-flop submodule
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(Q)
    );

endmodule

// 2:1 Multiplexer
module Mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// D flip-flop with synchronous reset disabled (no reset)
module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule