module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

typedef enum logic [2:0] {
    S0 = 3'd0, // no bits matched
    S1 = 3'd1, // matched '1'
    S2 = 3'd2, // matched '10'
    S3 = 3'd3, // matched '100'
    S4 = 3'd4  // matched '1001'
} state_t;

state_t state, next_state;

always @(*) begin
    // Default next state
    next_state = S0;
    MATCH = 1'b0;

    case(state)
        S0: begin
            if (IN) next_state = S1;
            else next_state = S0;
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
            if (IN) begin
                next_state = S4;
                MATCH = 1'b0; // matched only after next transition
            end else begin
                next_state = S0;
                MATCH = 1'b0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S1;
                MATCH = 1'b1; // match occurs when IN=1 and in S4 (final '1')
            end else begin
                next_state = S2;
                MATCH = 1'b0;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= MATCH;
    end
end

endmodule