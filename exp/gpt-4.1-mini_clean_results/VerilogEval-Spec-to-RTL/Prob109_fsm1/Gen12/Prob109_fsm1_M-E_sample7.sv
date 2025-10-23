module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;

    // Asynchronous reset to state B (1), state updates on rising edge of clk
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // B = 1
        else begin
            // Next state logic derived from state diagram:
            // B(1) --0--> A(0)
            // B(1) --1--> B(1)
            // A(0) --0--> B(1)
            // A(0) --1--> A(0)
            // Boolean expression:
            // next_state = (state & in) | (~state & ~in);
            // Because if in == state => stay in same state; else flip state
            state <= (state & in) | (~state & ~in);
        end
    end

    // Moore output equals current state bit (B=1 outputs 1, A=0 outputs 0)
    assign out = state;

endmodule