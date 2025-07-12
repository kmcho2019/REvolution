module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
typedef enum {
    IDLE,
    S1,
    S10,
    S100,
    S1001,
    S10011
} state_t;

reg [2:0] current_state, next_state;

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
            MATCH = 1'b0;
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            MATCH = 1'b0;
            if (IN == 1'b0)
                next_state = S10;
            else
                next_state = S1;
        end
        S10: begin
            MATCH = 1'b0;
            if (IN == 1'b0)
                next_state = S100;
            else
                next_state = S1;
        end
        S100: begin
            MATCH = 1'b0;
            if (IN == 1'b1)
                next_state = S1001;
            else
                next_state = IDLE;
        end
        S1001: begin
            MATCH = 1'b0;
            if (IN == 1'b1)
                next_state = S10011;
            else
                next_state = S10;
        end
        S10011: begin
            MATCH = IN;  // Output 1 only if we're in S10011 and IN is 1
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S10;
        end
        default: begin
            MATCH = 1'b0;
            next_state = IDLE;
        end
    endcase
end

endmodule