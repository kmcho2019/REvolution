module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding - 3 bits suffice for 8 states:
    // S0..S6 count consecutive ones (0 to 6)
    // SO = output state (disc or flag output asserted)
    // SE = error state (7 or more ones)
    localparam 
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        SO = 3'd7, // output state: disc or flag asserted
        SE = 4'd8; // error state, need 4 bits for 9 states actually

    // Since SE requires a 4th bit, use 4 bits for state:
    reg [3:0] state, next_state;

    // To distinguish disc or flag output in SO state
    reg output_flag; // 0 = disc, 1 = flag

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S2 : S0;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S0;
            S4: next_state = (in) ? S5 : S0;
            S5: begin
                if (in)
                    next_state = S6;
                else
                    next_state = SO; // disc output state
            end
            S6: begin
                if (in)
                    next_state = SE; // error state
                else
                    next_state = SO; // flag output state
            end
            SO: next_state = S0; // after output state, return to idle
            SE: next_state = (in) ? SE : S0; // stay in error on ones, exit on zero
            default: next_state = S0;
        endcase
    end

    // output_flag logic: indicates whether SO outputs disc or flag
    // Set synchronously on state transition to SO
    reg next_output_flag;

    always @(*) begin
        next_output_flag = output_flag;
        if (state == S5 && in == 1'b0) 
            next_output_flag = 1'b0; // disc output
        else if (state == S6 && in == 1'b0)
            next_output_flag = 1'b1; // flag output
    end

    // Output logic (Moore): depends only on current state and output_flag
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        if (state == SO) begin
            if (output_flag == 1'b0)
                disc = 1'b1;
            else
                flag = 1'b1;
        end else if (state == SE) begin
            err = 1'b1;
        end
    end

    // State and output_flag register update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            output_flag <= 1'b0;
        end else begin
            state <= next_state;
            output_flag <= next_output_flag;
        end
    end

endmodule