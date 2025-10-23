module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next-state logic: compact expression matching the FSM transitions
    always @(*) begin
        // Using equivalent logic: next_state = state ^ ~in;
        next_state = state ^ ~in;
    end

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore machine output: output depends only on current state
    assign out = state;

endmodule