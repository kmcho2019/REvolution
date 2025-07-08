module fsm(
    input        IN,
    input        CLK,
    input        RST,
    output reg   MATCH
);

    // State encoding for the sequence detection "10011"
    // States represent how many bits matched so far:
    // S0: no bits matched
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    typedef enum logic [2:0] {
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4
    } state_t;

    state_t current_state, next_state;

    // Next state logic - Mealy FSM
    always @(*) begin
        case (current_state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else // IN=1
                    next_state = S1; // stay if another 1 appears
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN=1
                    next_state = S1; // restart from first 1
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else // IN=0
                    next_state = S0;
            end
            S4: begin
                // Final state: matched 1001, now expecting last '1' for full match
                // But here we detected 1001, waiting for last 1:
                if (IN == 1'b1)
                    next_state = S1; // after match, check if new sequence starts at this 1
                else
                    next_state = S2; // if 0, next should be second zero in sequence
            end
            default: next_state = S0;
        endcase
    end

    // Output logic: MATCH=1 when sequence "10011" detected at last '1'
    // The last input '1' occurs when current_state = S4 and IN=1
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // Match condition: current state is S4 and input IN=1 triggers match
            if (current_state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule