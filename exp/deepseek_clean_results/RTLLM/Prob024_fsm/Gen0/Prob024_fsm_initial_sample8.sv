module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
typedef enum logic [2:0] {
    IDLE,
    S1,
    S10,
    S100,
    S1001,
    S10011
} state_t;

// State registers
state_t current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        IDLE: begin
            MATCH = 0;
            if (IN == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        
        S1: begin
            MATCH = 0;
            if (IN == 1'b0) begin
                next_state = S10;
            end else begin
                next_state = S1;  // Stay in S1 if we get another '1'
            end
        end
        
        S10: begin
            MATCH = 0;
            if (IN == 1'b0) begin
                next_state = S100;
            end else begin
                next_state = S1;  // '10' followed by '1' -> back to S1
            end
        end
        
        S100: begin
            MATCH = 0;
            if (IN == 1'b1) begin
                next_state = S1001;
            end else begin
                next_state = IDLE;  // '100' followed by '0' -> reset
            end
        end
        
        S1001: begin
            MATCH = 0;
            if (IN == 1'b1) begin
                next_state = S10011;
            end else begin
                next_state = S10;  // '1001' followed by '0' -> back to S10
            end
        end
        
        S10011: begin
            MATCH = (IN == 1'b1) ? 1'b1 : 1'b0;
            if (IN == 1'b1) begin
                next_state = S1;  // Start new sequence with this '1'
            end else begin
                next_state = S10; // Start new sequence with '10'
            end
        end
        
        default: begin
            MATCH = 0;
            next_state = IDLE;
        end
    endcase
end

endmodule