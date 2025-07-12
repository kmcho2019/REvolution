module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

// States encode count of consecutive 1s after last zero:
// S0: 0 ones
// S1..S5: 1..5 consecutive ones
// S6: 6 consecutive ones
// S7: error (7 or more consecutive ones)

typedef enum logic [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6,
    S7 = 3'd7
} state_t;

reg [2:0] state, next_state;
reg [2:0] prev_state;

// Next state logic: pure combinational
always @(*) begin
    case (state)
        S0: next_state = in ? S1 : S0;
        S1: next_state = in ? S2 : S0;
        S2: next_state = in ? S3 : S0;
        S3: next_state = in ? S4 : S0;
        S4: next_state = in ? S5 : S0;
        S5: next_state = in ? S6 : S0;  // zero after 5 ones => stuffed bit
        S6: next_state = in ? S7 : S0;  // zero after 6 ones => flag, else error if 7th 1
        S7: next_state = S7;             // remain in error state
        default: next_state = S0;
    endcase
end

// State registers and prev_state tracking
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        prev_state <= S0;
    end else begin
        prev_state <= state;
        state <= next_state;
    end
end

// Output logic: Moore outputs assigned from prev_state and current state transitions
always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        // disc: zero stuffed bit detected when transition from S5 to S0
        disc <= (prev_state == S5 && state == S0) ? 1'b1 : 1'b0;

        // flag: flag detected when transition from S6 to S0
        flag <= (prev_state == S6 && state == S0) ? 1'b1 : 1'b0;

        // err: asserted continuously in error state S7
        err  <= (state == S7) ? 1'b1 : 1'b0;
    end
end

endmodule