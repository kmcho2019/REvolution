module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg state; // current state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // reset to state 0 (OFF)
    end else begin
        state <= (~state & j) | (state & ~k); // next state logic
    end
end

assign out = state; // output directly from state

endmodule