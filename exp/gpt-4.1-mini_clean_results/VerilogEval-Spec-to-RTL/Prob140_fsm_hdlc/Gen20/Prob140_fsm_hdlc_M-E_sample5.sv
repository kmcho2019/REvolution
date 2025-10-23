module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: one-hot or binary with explicit states for 0 to 7 consecutive ones
    // Using binary encoding 3-bit for convenience
    typedef enum logic [2:0] {
        S0 = 3'd0, // zero consecutive ones
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5, // 5 consecutive ones
        S6 = 3'd6, // 6 consecutive ones
        S7 = 3'd7  // 7 or more consecutive ones - error
    } state_t;

    state_t state, next_state;

    // Next outputs for Moore FSM
    reg disc_next, flag_next, err_next;

    always @(*) begin
        // Default next state and outputs
        next_state = state;
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

        case(state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0; // remain in S0
                // no outputs in S0
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in)
                    next_state = S6;
                else begin
                    // zero after five ones means discard stuffed zero
                    next_state = S0;
                    disc_next = 1'b1;
                end
            end
            S6: begin
                if (in)
                    next_state = S7;  // error on 7+ ones
                else begin
                    // zero after six ones means flag
                    next_state = S0;
                    flag_next = 1'b1;
                end
            end
            S7: begin
                // error state stays in S7 on ones
                if (in)
                    next_state = S7;
                else
                    next_state = S0; // reset error on zero
                err_next = 1'b1;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule