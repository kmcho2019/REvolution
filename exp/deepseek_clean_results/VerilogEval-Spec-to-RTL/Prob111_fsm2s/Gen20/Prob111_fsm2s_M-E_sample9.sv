module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding - single bit for minimal area
    reg state;
    wire next_state;

    // Next state logic - optimized combinational path
    assign next_state = (state & ~k) | (~state & j);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF state
        end else begin
            state <= next_state;
        end
    end

    // Moore output - directly from state
    assign out = state;

    // Synthesis directives
    (* dont_touch = "true" *) reg state_synth;
    (* optimize_power = "true" *) wire out_synth;

endmodule