module TopModule(
    input  clk,
    input  d,
    output q
);

reg latch_q;
reg ff_q;

// Transparent latch triggered when clk is low (falling phase)
always @(*) begin
    if (~clk)
        latch_q = d;
    else
        latch_q = latch_q; // hold value
end

// Positive edge-triggered flip-flop samples latch output
always @(posedge clk) begin
    ff_q <= d;
end

// Output mux: when clk is high, use flip-flop; when low, use latch
assign q = clk ? ff_q : latch_q;

endmodule