module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot states representing number of consecutive ones seen: 0..7+
    typedef enum logic [7:0] {
        S0 = 8'b00000001, // 0 consecutive ones
        S1 = 8'b00000010,
        S2 = 8'b00000100,
        S3 = 8'b00001000,
        S4 = 8'b00010000,
        S5 = 8'b00100000,
        S6 = 8'b01000000,
        S7 = 8'b10000000  // 7 or more consecutive ones (error state)
    } state_t;

    state_t state, next_state;

    // Next state logic combinational
    always @(*) begin
        case(state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = S7;  // remain in error state
            default: next_state = S0;
        endcase
    end

    // Outputs: Moore type, depend only on current state and input
    // disc = one cycle after seeing exactly 5 consecutive ones and then a zero (i.e., after S5 + in=0)
    // flag = one cycle after seeing exactly 6 consecutive ones and then a zero (S6 + in=0)
    // err  = one cycle after reaching state S7 (7 or more ones)
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case(state)
            S5: if (in == 1'b0) disc = 1'b1;
            S6: if (in == 1'b0) flag = 1'b1;
            S7: err = 1'b1;
        endcase
    end

    // Sequential state update and synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule