module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
    } state_t;

    state_t state, next_state;

    // Next state logic and MATCH output (Mealy: MATCH depends on current input and next state)
    always @(*) begin
        // Default values
        next_state = S0;
        MATCH = 1'b0;

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
                    next_state = S1; // if input is 1 again, remain here (sequence start)
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // fallback to S1 if input is 1 (possible new sequence start)
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end

            S4: begin
                if (IN == 1'b1) begin
                    next_state = S1;
                    MATCH = 1'b1;  // sequence "10011" detected on this input
                end else if (IN == 1'b0) begin
                    next_state = S2;
                end
            end

            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and asynchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is combinational and assigned in always @(*) above,
            // but since MATCH is reg and must be synchronous with CLK and RST,
            // we assign it here to hold the Mealy output.
            MATCH <= MATCH;
        end
    end

endmodule