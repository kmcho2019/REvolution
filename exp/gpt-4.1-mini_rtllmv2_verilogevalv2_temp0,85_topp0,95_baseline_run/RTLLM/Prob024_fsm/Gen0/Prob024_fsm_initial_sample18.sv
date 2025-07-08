module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding representing how many bits matched so far:
    // S0: no match yet
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    // When in S4 and IN=1, sequence matched (10011)
    typedef enum logic [2:0] {
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4
    } state_t;

    state_t state, next_state;

    // Next state logic and MATCH output combinational logic
    always @(*) begin
        MATCH = 1'b0; // default no match
        case (state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // still 1, stay in S1
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart from first 1
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0; // no partial match
            end
            S4: begin
                if (IN == 1'b1) begin
                    MATCH = 1'b1; // sequence detected at this input
                    next_state = S1; // because last two bits are "11", can start from S1 again (overlap)
                end else if (IN == 1'b0)
                    next_state = S2; // the sequence so far is '1001', next 0 matches S2 state
                else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // State register update with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is combinational and assigned above, so no need to update here again
            // but because MATCH is reg and output, assign here to be sure 
            // Actually, in Mealy FSM MATCH is combinational from current state and input,
            // but because MATCH assigned in always @(*) and also reset in sequential block,
            // assign MATCH only in combinational block except reset condition.
        end
    end

endmodule