module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);
    reg state_reg = 0; // Initialize to 0 matching waveform initial state

    // Next state combinational logic derived from waveform analysis
    assign q = (state_reg & ~a & ~b) | (~state_reg & b);
    assign state = state_reg;

    // State register update on rising edge of clk
    always @(posedge clk) begin
        state_reg <= q;
    end

endmodule