module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    MATCH_STATE
} state_t;

// Current and next state variables
state_t current_state, next_state;

// Output variable
logic match;

// Combinational logic for next state and output
always_comb begin
    case (current_state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
                match = 0;
            end else begin
                next_state = IDLE;
                match = 0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
                match = 0;
            end else begin
                next_state = IDLE;
                match = 0;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
                match = 0;
            end else begin
                next_state = IDLE;
                match = 0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                match = 0;
            end else begin
                next_state = IDLE;
                match = 0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = MATCH_STATE;
                match = 1;
            end else begin
                next_state = IDLE;
                match = 0;
            end
        end
        MATCH_STATE: begin
            if (IN) begin
                next_state = IDLE;
                match = 0;
            end else begin
                next_state = IDLE;
                match = 0;
            end
        end
        default: begin
            next_state = IDLE;
            match = 0;
        end
    endcase
end

// Sequential logic for state register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        MATCH <= match;
    end
end

endmodule