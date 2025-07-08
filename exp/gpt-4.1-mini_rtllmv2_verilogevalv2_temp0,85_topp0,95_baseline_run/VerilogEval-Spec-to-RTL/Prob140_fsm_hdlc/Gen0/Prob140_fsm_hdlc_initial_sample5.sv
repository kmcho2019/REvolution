module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum logic [3:0] {
        S0 = 4'd0,  // 0 consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7  // error state (7 or more ones)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: if (in) next_state = S1; else next_state = S0;
            S1: if (in) next_state = S2; else next_state = S0;
            S2: if (in) next_state = S3; else next_state = S0;
            S3: if (in) next_state = S4; else next_state = S0;
            S4: if (in) next_state = S5; else next_state = S0;
            S5: if (in) next_state = S6; else next_state = S0;
            S6: if (in) next_state = S7; else next_state = S0;
            S7: if (in) next_state = S7; else next_state = S0;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and output generation
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            // Outputs depend on previous state and current input 'in'
            // disc: zero after 5 ones (prev state S5 and in=0)
            disc <= (state == S5) && (in == 1'b0);
            // flag: zero after 6 ones (prev state S6 and in=0)
            flag <= (state == S6) && (in == 1'b0);
            // err: if in error state (S7)
            err  <= (state == S7);

            state <= next_state;
        end
    end

endmodule