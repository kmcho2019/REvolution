module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state; // 0 = A, 1 = B

    wire next_state = state ^ ~in; // next state logic

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else if (state != next_state)
            state <= next_state; // update only if different to reduce toggling
    end

    assign out = state;

endmodule