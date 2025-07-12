module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Next-state combinational logic with simplified ternary operator for PPA benefits
    always @(*) begin
        next_state = (state == B) ? (in ? B : A) : (in ? A : B);
    end

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore FSM output depends only on current state (glitch-free)
    assign out = (state == B);

endmodule