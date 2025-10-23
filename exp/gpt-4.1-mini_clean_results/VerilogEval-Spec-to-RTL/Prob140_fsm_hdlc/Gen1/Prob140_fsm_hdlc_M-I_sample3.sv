module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define FSM states to count consecutive ones and output signals
    typedef enum reg [3:0] {
        S0    = 4'd0,  // zero consecutive ones
        S1    = 4'd1,  // 1 one
        S2    = 4'd2,  // 2 ones
        S3    = 4'd3,  // 3 ones
        S4    = 4'd4,  // 4 ones
        S5    = 4'd5,  // 5 ones
        S6    = 4'd6,  // 6 ones
        S7    = 4'd7,  // 7 or more ones (error detection starts here)
        DISC  = 4'd8,  // output disc=1 cycle
        FLAG  = 4'd9,  // output flag=1 cycle
        ERR   = 4'd10  // output err=1 cycle
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
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
                    next_state = S6;
                else
                    next_state = DISC; // 5 ones + 0 detected, go to disc output state next cycle
            end
            S6: begin
                if (in)
                    next_state = S7; // 7 ones detected -> error condition
                else
                    next_state = FLAG; // 6 ones + 0 detected, go to flag output state next cycle
            end
            S7: begin
                // 7 or more ones, error detected
                // Stay here or move to ERR output state to assert err for one cycle
                // To assert err for one cycle, move to ERR state:
                next_state = ERR;
            end
            DISC: begin
                // After disc output asserted for 1 cycle, return to normal counting depending on input
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            FLAG: begin
                // After flag output asserted for 1 cycle, return to counting
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            ERR: begin
                // After err output cycle, go back to counting.
                // If input=1, go to S1 (start new count), else S0
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore): outputs depend only on current state
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        case(state)
            DISC: disc = 1'b1;
            FLAG: flag = 1'b1;
            ERR:  err  = 1'b1;
            default: begin
                disc = 1'b0;
                flag = 1'b0;
                err  = 1'b0;
            end
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0; // Reset to initial state assuming previous bit zero
        end else begin
            state <= next_state;
        end
    end

endmodule