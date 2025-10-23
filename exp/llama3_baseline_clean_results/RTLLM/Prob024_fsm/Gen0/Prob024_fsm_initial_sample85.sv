module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states as parameters for clarity and ease of modification
parameter S0 = 5'b00001, // Initial state
          S1 = 5'b00010, // State after seeing the first "1"
          S2 = 5'b00100, // State after seeing "10"
          S3 = 5'b01000, // State after seeing "100"
          S4 = 5'b10000, // State after seeing "1001"
          S5 = 5'b00000; // Not used but defined for completeness

reg [4:0] current_state; // Register to hold the current state

// Combinational logic to determine the next state
always @(*) begin
    case(current_state)
        S0: begin
            if(IN)
                current_state = S1;
            else
                current_state = S0;
        end
        S1: begin
            if(!IN)
                current_state = S2;
            else
                current_state = S0;
        end
        S2: begin
            if(!IN)
                current_state = S3;
            else
                current_state = S0;
        end
        S3: begin
            if(IN)
                current_state = S4;
            else
                current_state = S0;
        end
        S4: begin
            if(IN)
                current_state = S4; // Stay in this state and assert MATCH
            else
                current_state = S0;
        end
        default: current_state = S0;
    endcase
end

// Sequential logic to update the current state and MATCH on the positive edge of CLK
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        // Update current_state based on the next state logic
        // This is not needed as current_state is updated combinatorially above
        // But we keep it for clarity on how the state machine progresses
        // current_state <= next_state;
        
        // Determine MATCH based on the current state
        if(current_state == S4 && IN) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule