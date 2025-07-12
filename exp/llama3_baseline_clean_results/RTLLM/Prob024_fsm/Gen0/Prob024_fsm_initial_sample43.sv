module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

parameter IDLE = 4'd0, // Initial state
          S1   = 4'd1, // State after detecting first '1'
          S2   = 4'd2, // State after detecting '0' after first '1'
          S3   = 4'd3, // State after detecting second '0'
          S4   = 4'd4, // State after detecting first '1' in second part of sequence
          S5   = 4'd5, // State after detecting second '1', match detected
          S6   = 4'd6, // Additional states for continuous detection support
          S7   = 4'd7,
          S8   = 4'd8;

reg [3:0] state, next_state;
reg match, next_match;

always @* begin
    next_state = state;
    next_match = 0;

    case(state)
        IDLE: begin
            if (IN) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (~IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (~IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = IDLE; // Incorrect sequence, reset to IDLE
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                next_match = 1; // Match detected
            end
            else next_state = IDLE; // Incorrect sequence, reset to IDLE
        end
        S5: begin
            if (IN) next_state = S6; // Continuous detection support
            else next_state = IDLE;
        end
        S6: begin
            if (~IN) next_state = S7;
            else next_state = S1; // Loop detection support
        end
        S7: begin
            if (~IN) next_state = S8;
            else next_state = S1;
        end
        S8: begin
            if (IN) begin
                next_state = S5;
                next_match = 1; // Match detected in loop
            end
            else next_state = IDLE; // Incorrect sequence, reset to IDLE
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        match <= 0;
    end
    else begin
        state <= next_state;
        match <= next_match;
    end
end

assign MATCH = match;

endmodule