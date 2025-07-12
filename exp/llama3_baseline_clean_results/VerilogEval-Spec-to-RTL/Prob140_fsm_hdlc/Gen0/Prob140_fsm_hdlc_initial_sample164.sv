module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    // States for the FSM
    enum logic [2:0] {
        S0,  // Initial state or after seeing a 0
        S1, S2, S3, S4, S5,  // Seeing 1 to 5 consecutive 1s
        S6,  // Seeing 6 consecutive 1s (potential flag)
        SERR  // Error state: Seeing 7 or more consecutive 1s
    } state, next_state;

    // Output logic
    always_comb begin
        disc = (state == S5 && in == 0);  // Signal to discard a bit after 5 consecutive 1s
        flag = (state == S6 && in == 0);  // Flag a frame boundary
        err = (state == SERR);  // Signal an error for 7 or more consecutive 1s
    end

    // State transitions
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case(state)
                S0: begin
                    if (in) state <= S1;
                    else state <= S0;
                end
                S1: begin
                    if (in) state <= S2;
                    else state <= S0;
                end
                S2: begin
                    if (in) state <= S3;
                    else state <= S0;
                end
                S3: begin
                    if (in) state <= S4;
                    else state <= S0;
                end
                S4: begin
                    if (in) state <= S5;
                    else state <= S0;
                end
                S5: begin
                    if (in) state <= S6;
                    else state <= S0;  // disc will be asserted this cycle due to in == 0
                end
                S6: begin
                    if (in) state <= SERR;  // More than 6 consecutive 1s, error
                    else state <= S0;  // flag will be asserted this cycle due to in == 0
                end
                SERR: begin
                    if (~in) state <= S0;  // Error condition cleared
                    else state <= SERR;  // Stay in error state if 1s continue
                end
                default: state <= S0;  // Should not reach here, default to initial state
            endcase
        end
    end

endmodule