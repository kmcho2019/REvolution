module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding: A=0, B=1
    reg state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // reset to B
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = (state & in) | (~state & ~in);
        out = state;
    end

endmodule