module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100,
    MATCH_STATE = 3'b101
} current_state, next_state;

// Update the current state based on the next state
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state based on the current state and input signal IN
always @(*) begin
    case (current_state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
                MATCH = 1'b0;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
                MATCH = 1'b0;
            end else begin
                next_state = S1;
                MATCH = 1'b0;
            end
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
                MATCH = 1'b0;
            end else begin
                next_state = S1;
                MATCH = 1'b0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                MATCH = 1'b0;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = MATCH_STATE;
                MATCH = 1'b1;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        MATCH_STATE: begin
            next_state = IDLE;
            MATCH = 1'b0;
        end
        default: begin
            next_state = IDLE;
            MATCH = 1'b0;
        end
    endcase
end

endmodule