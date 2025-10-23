module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// States represent count of consecutive 1s encountered:
// s0: 0 consecutive 1s
// s1: 1 consecutive 1
// s2: 2 consecutive 1s
// s3: 3 consecutive 1s
// s4: 4 consecutive 1s
// s5: 5 consecutive 1s
// s6: 6 consecutive 1s
// s7: 7 or more consecutive 1s (error state)
typedef enum logic [3:0] {
    s0 = 4'd0,
    s1 = 4'd1,
    s2 = 4'd2,
    s3 = 4'd3,
    s4 = 4'd4,
    s5 = 4'd5,
    s6 = 4'd6,
    s7 = 4'd7
} state_t;

state_t state, next_state;

// On synchronous reset and clock, update state
always @(posedge clk) begin
    if (reset)
        state <= s0;
    else
        state <= next_state;
end

// Next state logic and output signals calculation
always @(*) begin
    // Defaults: no output asserted
    disc = 1'b0;
    flag = 1'b0;
    err  = 1'b0;
    next_state = state;

    case(state)
        s0: begin
            if (in)
                next_state = s1;
            else
                next_state = s0;
        end
        s1: begin
            if (in)
                next_state = s2;
            else
                next_state = s0;
        end
        s2: begin
            if (in)
                next_state = s3;
            else
                next_state = s0;
        end
        s3: begin
            if (in)
                next_state = s4;
            else
                next_state = s0;
        end
        s4: begin
            if (in)
                next_state = s5;
            else
                next_state = s0;
        end
        s5: begin
            if (in)
                next_state = s6;
            else begin
                // Pattern "0111110" detected: a zero after 5 ones
                // signal disc output next cycle
                disc = 1'b1;
                next_state = s0;
            end
        end
        s6: begin
            if (in)
                next_state = s7;  // 7 consecutive ones, error state
            else begin
                // Pattern "01111110" detected: zero after 6 ones
                // signal flag output next cycle
                flag = 1'b1;
                next_state = s0;
            end
        end
        s7: begin
            // error: 7 or more consecutive 1s
            err = 1'b1;
            if (in)
                next_state = s7;  // stay in error if more ones
            else
                next_state = s0;  // reset error on zero input
        end
        default: begin
            next_state = s0;
        end
    endcase
end

endmodule