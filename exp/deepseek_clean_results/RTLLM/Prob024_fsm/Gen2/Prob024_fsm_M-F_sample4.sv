module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// State definitions
parameter S0 = 3'd0;  // Initial state
parameter S1 = 3'd1;  // Received '1'
parameter S2 = 3'd2;  // Received '10'
parameter S3 = 3'd3;  // Received '100'
parameter S4 = 3'd4;  // Received '1001'
parameter S5 = 3'd5;  // Received '10011' (complete match)

reg [2:0] current_state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        S0: next_state = IN ? S1 : S0;
        S1: next_state = IN ? S1 : S2;
        S2: next_state = IN ? S1 : S3;
        S3: next_state = IN ? S4 : S0;
        S4: begin
            if (IN) begin
                next_state = S5;  // Complete match
            end else begin
                next_state = S2;  // Partial match "1001" followed by 0
            end
        end
        S5: next_state = IN ? S1 : S2;  // After complete match, continue detection
        default: next_state = S0;
    endcase
end

// Mealy output logic (depends on current state and input)
always @(*) begin
    case (current_state)
        S4: MATCH = IN ? 1'b1 : 1'b0;  // Only assert when last '1' is received
        default: MATCH = 1'b0;
    endcase
end

endmodule