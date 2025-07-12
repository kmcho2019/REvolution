module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// State encoding for count of consecutive 1s after last 0:
// 0 = no consecutive ones
// 1 to 5 = count of 1s
// 6 = six consecutive 1s
// 7 = error state (7 or more consecutive 1s)

reg [3:0] state, next_state;

localparam S0 = 4'd0; // 0 consecutive 1s
localparam S1 = 4'd1; // 1 consecutive 1
localparam S2 = 4'd2; // 2 consecutive 1s
localparam S3 = 4'd3; // 3 consecutive 1s
localparam S4 = 4'd4; // 4 consecutive 1s
localparam S5 = 4'd5; // 5 consecutive 1s
localparam S6 = 4'd6; // 6 consecutive 1s
localparam S7 = 4'd7; // error state (7+ consecutive 1s)

always @(*) begin
    // Default next state is current state
    next_state = state;

    case (state)
        S0: begin
            if (in)
                next_state = S1;
            else
                next_state = S0;
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
                next_state = S6; // 6 consecutive 1s
            else
                next_state = S0; // zero stuffed bit after 5 ones
        end
        S6: begin
            if (in)
                next_state = S7; // error condition - 7 consecutive 1s
            else
                next_state = S0; // zero after 6 ones -> flag boundary
        end
        S7: begin
            // Stay in error state
            next_state = S7;
        end
        default: next_state = S0;
    endcase
end

always @(posedge clk) begin
    if (reset)
        state <= S0;
    else
        state <= next_state;
end

// Outputs depend only on current state (Moore FSM)
// Assert outputs for one clock cycle after the condition occurs
// - disc is asserted when previous state was S5 and current input zero (i.e. transition S5->S0)
// - flag is asserted when previous state was S6 and current input zero (transition S6->S0)
// - err is asserted whenever in error state S7

reg prev_in;
reg [3:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
        prev_in <= 1'b0;
        prev_state <= S0;
    end else begin
        // Update outputs according to previous state and previous input (to detect transitions)
        // Because outputs asserted for the cycle *after* condition occurs
        // Condition to assert disc: previous state = S5 and prev_in=1 and current in=0 (transition from 5 ones + in=0)
        // Since inputs are processed and state changed synchronously, the outputs reflect previous cycle condition
        
        disc <= (prev_state == S5 && prev_in == 1'b1 && in == 1'b0) ? 1'b1 : 1'b0;
        flag <= (prev_state == S6 && prev_in == 1'b1 && in == 1'b0) ? 1'b1 : 1'b0;
        err  <= (state == S7) ? 1'b1 : 1'b0;

        prev_in <= in;
        prev_state <= state;
    end
end

endmodule