module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Next state combinational logic as single boolean expression:
    // next_state = (bump_left & ~bump_right) | (bump_left & bump_right & ~state);
    // Explanation:
    // - bump_left & ~bump_right forces walk_right (1)
    // - bump_right & ~bump_left forces walk_left (0), expressed implicitly since next_state=0 if not assigned 1 above or toggled
    // - bump_left & bump_right toggles state
    // So we combine toggling and bump_left bump_right handling by:
    // next_state = (bump_left & ~bump_right) | (bump_left & bump_right & ~state) | (~bump_left & bump_right & 1'b0) which simplifies,
    // therefore next_state can be derived as:
    //   If bumped both sides: toggle state
    //   Else if bumped left only: 1
    //   Else if bumped right only: 0
    //   Else hold state
    // We use the expression:
    //   next_state = (bump_left & ~bump_right) | (bump_left & bump_right & ~state) | (~bump_left & bump_right & 1'b0) | (else hold state)
    // But to cover all, we do a conditional assignment using a boolean expression:
    // next_state = bump_left & ~bump_right ? 1 :
    //              bump_right & ~bump_left ? 0 :
    //              bump_left & bump_right ? ~state :
    //              state;
    // The single boolean expression covering all cases is:
    // next_state = (bump_left & ~bump_right) | (bump_left & bump_right & ~state) | (~bump_left & bump_right & 1'b0) | (state & ~(bump_left | bump_right));
    // which can be simplified to:
    // next_state = ((bump_left & ~bump_right) | (bump_left & bump_right & ~state)) | (state & ~(bump_left | bump_right));
    // but this does not handle bump_right only case (which forces 0).
    // Instead, next_state can be expressed as:
    // next_state = (bump_left & ~bump_right) | (bump_left & bump_right & ~state) | (~bump_left & bump_right & 1'b0) | (state & ~ (bump_left | bump_right))
    // Since (~bump_left & bump_right & 1'b0) = 0, it means that if bump_right only, next_state = 0.
    // So the whole expression is:
    // next_state = (bump_left & ~bump_right) | (bump_left & bump_right & ~state) | (state & ~ (bump_left | bump_right));

    always @(*) begin
        next_state = ((bump_left & ~bump_right) | (bump_left & bump_right & ~state) | (state & ~(bump_left | bump_right)));
    end

    // Outputs directly derived from state (Moore FSM)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule