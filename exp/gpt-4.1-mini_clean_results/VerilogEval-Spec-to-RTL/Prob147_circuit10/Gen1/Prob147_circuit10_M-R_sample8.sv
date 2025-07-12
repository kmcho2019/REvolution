module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

    reg state_reg;
    wire next_state;

    // Compute next state combinationally
    assign next_state = (~state_reg & a) | (state_reg & b);

    // Output q is next_state combinational output
    assign q = next_state;

    // Output current state
    assign state = state_reg;

    // State register updated on positive clock edge
    always @(posedge clk) begin
        state_reg <= next_state;
    end

endmodule