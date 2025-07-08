module fsm (
    input        IN,
    input        CLK,
    input        RST,
    output reg   MATCH
);

    // States encoding for sequence "1 0 0 1 1"
    typedef enum logic [2:0] {
        S0 = 3'd0, // no match yet
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4  // matched '1001'
    } state_t;

    state_t current_state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
        next_state = S0;
        MATCH = 1'b0;
        case (current_state)
            S0: begin
                if (IN == 1'b1) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (IN == 1'b0) next_state = S2;
                else next_state = S1; // If IN=1 again, stay in S1 (as sequence start)
            end
            S2: begin
                if (IN == 1'b0) next_state = S3;
                else if (IN == 1'b1) next_state = S1; // Restart matching from S1
            end
            S3: begin
                if (IN == 1'b1) next_state = S4;
                else next_state = S0;
            end
            S4: begin
                if (IN == 1'b1) begin
                    next_state = S1;
                    MATCH = 1'b1; // Sequence matched at last IN=1
                end else if (IN == 0) begin
                    next_state = S2;
                    MATCH = 1'b1; // Sequence matched at last IN=1 (previous clock)
                end else begin
                    next_state = S0;
                end
            end
            default: next_state = S0;
        endcase
    end

    // State update on clock edge and synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            // MATCH is already assigned in combinational, but must latch it here for Mealy output timing
            if (current_state == S4 && IN == 1'b1)
                MATCH <= 1'b1;
            else if (current_state == S4 && IN == 1'b0)
                MATCH <= 1'b1;
            else
                MATCH <= 1'b0;
        end
    end

endmodule