// Positive edge-triggered D flip-flop with synchronous clock
module DFlipFlop (
    input  clk,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// TopModule with combinational mux logic using assign and separate DFlipFlop
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    wire d_input;

    // Combinational mux logic: select r_in if L=1, else q_in
    assign d_input = L ? r_in : q_in;

    // Instantiate D flip-flop: latch d_input on rising clk
    DFlipFlop u_dff (
        .clk(clk),
        .d(d_input),
        .q(Q)
    );

endmodule