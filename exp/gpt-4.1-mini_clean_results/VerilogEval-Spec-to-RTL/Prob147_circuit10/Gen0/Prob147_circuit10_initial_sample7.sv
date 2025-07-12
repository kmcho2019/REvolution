module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg state_reg;
    wire next_state;

    // Next state logic:
    // If state=0, next_state = a ^ b
    // If state=1, next_state = ~(a | b)
    assign next_state = (~state_reg & (a ^ b)) | (state_reg & ~(a | b));

    // Output q is next_state combinationally
    assign q = next_state;

    // Output current state
    assign state = state_reg;

    // Flip-flop for state
    always @(posedge clk) begin
        state_reg <= next_state;
    end

endmodule