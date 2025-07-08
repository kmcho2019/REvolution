module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'd0, // initial state, no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final match state, but output is Mealy)
    } state_t;

    state_t state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            S0: begin
                if(IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if(IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // '1' again means stay in S1 (could start again)
            end
            S2: begin
                if(IN == 1'b0)
                    next_state = S3;
                else if(IN == 1'b1)
                    next_state = S1; // restart sequence if '1'
                else
                    next_state = S0;
            end
            S3: begin
                if(IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if(IN == 1'b1)
                    next_state = S5; // final match state
                else if(IN == 1'b0)
                    next_state = S2; // overlapping detection: from S4 on '0' go to S2 ('10')
                else
                    next_state = S0;
            end
            S5: begin
                // After match, check next input for overlap:
                // The sequence ends with '1', so we can re-enter S1 on '1' or S2 on '0'
                if(IN == 1'b1)
                    next_state = S1;
                else if(IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Output and state update logic (sequential)
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;

            // Mealy output: MATCH = 1 when current input completes sequence "10011" (at S4 + IN=1)
            if(state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule