// 2:1 Multiplexer module
module Mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// D Flip-Flop module with synchronous clocking
module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end

    initial begin
        q = 1'b0;
    end
end

// TopModule instantiates Mux2to1 and DFF
module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire mux_out;

    // Instantiate 2:1 mux: if L=1 select r_in else q_in
    Mux2to1 u_mux (
        .sel(L),
        .in0(q_in),
        .in1(r_in),
        .out(mux_out)
    );

    // Instantiate D flip-flop to latch mux_out on rising clk
    DFF u_dff (
        .clk(clk),
        .d(mux_out),
        .q(Q)
    );

endmodule