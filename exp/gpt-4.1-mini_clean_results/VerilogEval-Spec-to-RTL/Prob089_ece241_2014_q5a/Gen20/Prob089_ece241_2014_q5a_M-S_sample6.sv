module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: 0 = COPY (no inversion), 1 = INVERT (inversion started)
    reg state, next_state;

    // Next state logic
    always @(*) begin
        if (state == 1'b0 && x == 1'b1)
            next_state = 1'b1; // start inversion on first '1'
        else
            next_state = state; // stay in current state
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // reset to COPY state
        else
            state <= next_state;
    end

    // Moore output: output = x XOR state (inversion bit)
    assign z = x ^ state;

endmodule