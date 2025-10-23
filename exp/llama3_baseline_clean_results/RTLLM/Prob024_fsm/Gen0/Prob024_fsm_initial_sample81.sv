module fsm(
    input IN,  // Input signal to the FSM
    input CLK, // Clock signal
    input RST, // Reset signal
    output MATCH  // Output signal indicating a match condition
);

// Define states
parameter IDLE = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;

reg [3:0] state; // Current state of the FSM
reg [3:0] nextState; // Next state of the FSM

// Assign initial state
initial state = IDLE;

// Combinational logic for next state and output
always @(*) begin
    case(state)
        IDLE: 
            if (IN) 
                nextState = S1;
            else 
                nextState = IDLE;
        S1: 
            if (!IN) 
                nextState = S2;
            else 
                nextState = S1;
        S2: 
            if (!IN) 
                nextState = S3;
            else 
                nextState = S1;
        S3: 
            if (IN) 
                nextState = S4;
            else 
                nextState = IDLE;
        S4: 
            if (IN) 
                nextState = S5;
            else 
                nextState = IDLE;
        S5: 
            if (IN) 
                nextState = S5; // Stay in S5 if input is 1 after sequence detected
            else 
                nextState = IDLE;
        default: nextState = IDLE;
    endcase
end

// Sequential logic for state transition and output
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= nextState;
        case(state)
            S5: MATCH <= IN; // MATCH is high at the last occurrence of IN=1 in the sequence
            default: MATCH <= 0;
        endcase
    end
end

endmodule