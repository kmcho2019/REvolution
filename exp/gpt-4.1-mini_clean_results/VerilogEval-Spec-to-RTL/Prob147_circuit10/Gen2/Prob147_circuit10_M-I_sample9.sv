module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg state_reg;
    wire next_state;

    // Next state logic matches waveform transitions
    assign next_state = (state_reg & ~b) | (~state_reg & a);

    // Output q combinational logic from waveform analysis
    assign q = (~state_reg & b) | (state_reg & ~a);

    // Current state output
    assign state = state_reg;

    // State register updated on positive clock edge
    always @(posedge clk) begin
        state_reg <= next_state;
    end

endmodule