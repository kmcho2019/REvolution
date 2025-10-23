module fsm(
    input IN,    // Input signal to the FSM
    input CLK,   // Clock signal used for synchronous operation
    input RST,   // Reset signal to initialize the FSM
    output MATCH // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state; // Current state of the FSM
reg [2:0] next_state; // Next state of the FSM

// Define the states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

always @(*) begin
    case(state)
        S0: begin
            if(IN)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if(!IN)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if(!IN)
                next_state = S3;
            else
                next_state = S1;
        end
        S3: begin
            if(IN)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if(IN)
                next_state = S5;
            else
                next_state = S0;
        end
        S5: begin
            if(IN)
                next_state = S5;
            else
                next_state = S2;
        end
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= S0;
        MATCH <= 0;
    end
    else begin
        state <= next_state;
        if(state == S5)
            MATCH <= 1;
        else
            MATCH <= 0;
    end
end

endmodule