module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // Define states as an enumerated type
    typedef enum logic [3:0] {
        S0 = 4'd0,  // 0 consecutive ones
        S1 = 4'd1,  // 1 consecutive one
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SD = 4'd7,  // disc output state
        SF = 4'd8,  // flag output state
        SE = 4'd9   // error state
    } state_t;

    state_t state, next_state;

    // Next state logic: simple if-else for clarity
    always @(*) begin
        next_state = S0; // default
        case(state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: next_state = (in) ? S6 : SD;  // disc on zero after five 1s
            S6: next_state = (in) ? SE : SF;  // flag on zero after six 1s, error on one after six 1s
            SD: next_state = (in) ? S1 : S0;
            SF: next_state = (in) ? S1 : S0;
            SE: next_state = (in) ? SE : S0;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore outputs: combinational based on current state
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule