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

// State transition logic (synchronous)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Output is combinational in Mealy machine
    end
end

// Next state and output logic (combinational)
always @(*) begin
    // Default assignments
    next_state = current_state;
    MATCH = 1'b0;
    
    case (current_state)
        IDLE: begin
            if (IN == 1'b1) begin
                next_state = S1;
            end
        end
        
        S1: begin
            if (IN == 1'b0) begin
                next_state = S10;
            end
            // Stay in S1 if input is 1
        end
        
        S10: begin
            if (IN == 1'b0) begin
                next_state = S100;
            end else begin
                next_state = S1;  // '10' followed by '1'
            end
        end
        
        S100: begin
            if (IN == 1'b1) begin
                next_state = S1001;
            end else begin
                next_state = IDLE;  // '100' followed by '0'
            end
        end
        
        S1001: begin
            if (IN == 1'b1) begin
                next_state = S10011;
            end else begin
                next_state = S10;  // '1001' followed by '0'
            end
        end
        
        S10011: begin
            MATCH = (IN == 1'b1) ? 1'b1 : 1'b0;
            if (IN == 1'b1) begin
                next_state = S1;  // Start new sequence
            end else begin
                next_state = S10; // '10011' followed by '0'
            end
        end
        
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule