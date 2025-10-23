module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    // State encoding:
    // 0 to 6: count of consecutive ones seen
    // 7: discard state (SD)
    // 3'b110 (6) + in=0 => flag state output next cycle
    // 3'b110 (6) + in=1 => error state (SE)
    // We'll use 3 bits for state:
    // 0-6: count of consecutive 1s
    // 7: discard/error output states combined, distinguished by a separate output logic

    localparam 
        SD = 3'd7, // discard output state
        SE = 3'd6; // error output state indicated when state=6 and input=1, handled explicitly

    reg [2:0] state, next_state;
    reg disc_r, flag_r, err_r;

    always @(*) begin
        disc_r = 1'b0;
        flag_r = 1'b0;
        err_r = 1'b0;
        case(state)
            3'd0, 3'd1, 3'd2, 3'd3, 3'd4: begin
                // counting ones 0 to 4
                if (in)
                    next_state = state + 1;
                else
                    next_state = 3'd0;
            end
            3'd5: begin
                if (in)
                    next_state = 3'd6; // 6 consecutive ones
                else
                    next_state = SD; // discard output state: zero after 5 ones must be discarded
            end
            3'd6: begin
                // 6 consecutive ones, next input decides
                if (in) begin
                    next_state = 3'd6; // stay here; error condition (7 or more ones)
                    err_r = 1'b1;
                end else begin
                    next_state = 3'd0;
                    flag_r = 1'b1; // flag output state (6 ones followed by 0)
                end
            end
            SD: begin
                // discard output state, next input resets or counts ones
                disc_r = 1'b1;
                if (in)
                    next_state = 3'd1;
                else
                    next_state = 3'd0;
            end
            default: begin
                // should not happen, reset to 0
                next_state = 3'd0;
            end
        endcase
    end

    // But above sets err_r, flag_r, disc_r combinationally - violates Moore FSM property that outputs depend only on state, not on input
    // The problem: in state 6, err is asserted only if in=1, and flag if in=0.
    // Since outputs must be only from state, we can encode these special conditions as separate states:
    // So add two extra states: SF (flag) and SE (error) as in original example.

    // Let's rewrite with 5 states:
    // 0 to 5: count of ones (0 to 5)
    // 6: after 6 ones input 0 => SF (flag state)
    // 7: SE (error state)

endmodule