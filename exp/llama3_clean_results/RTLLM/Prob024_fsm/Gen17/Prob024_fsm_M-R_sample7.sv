module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

// Define the states of the sequence detection
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    MATCH_STATE
} state, next_state;

// Register to store the current state
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and MATCH signal
always @(*) begin
    case(state)
        IDLE: begin
            if(IN) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
            MATCH = 1'b0;
        end
        S1: begin
            if(!IN) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
            MATCH = 1'b0;
        end
        S2: begin
            if(!IN) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
            MATCH = 1'b0;
        end
        S3: begin
            if(IN) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
            MATCH = 1'b0;
        end
        S4: begin
            if(IN) begin
                next_state = MATCH_STATE;
            end else begin
                next_state = IDLE;
            end
            MATCH = 1'b0;
        end
        MATCH_STATE: begin
            next_state = IDLE;
            MATCH = 1'b1;
        end
        default: begin
            next_state = IDLE;
            MATCH = 1'b0;
        end
    endcase
end

endmodule