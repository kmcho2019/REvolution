module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            STATE_A: next_state = (in) ? STATE_A : STATE_B;
            STATE_B: next_state = (in) ? STATE_B : STATE_A;
            default: next_state = STATE_B; // Default safe state
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_B; // Reset to state B
        else
            state <= next_state;
    end

    // Moore output: depends only on current state
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;       // Output for state B
        else
            out <= state == STATE_B ? 1'b1 : 1'b0;
    end

endmodule