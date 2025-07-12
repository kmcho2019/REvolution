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

// TopModule combines mux function with DFlipFlop instance internally
module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);

    wire mux_out;

    // Implement mux function directly using assign statement
    assign mux_out = L ? r_in : q_in;

    // Instantiate only the D flip-flop
    DFlipFlop dff_inst (
        .clk(clk),
        .d(mux_out),
        .q(Q)
    );

endmodule