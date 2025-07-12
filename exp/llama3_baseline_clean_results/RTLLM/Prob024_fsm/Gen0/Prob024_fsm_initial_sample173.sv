module fsm(
    input IN,  // Input signal to the FSM
    input CLK,  // Clock signal
    input RST,  // Reset signal
    output reg MATCH  // Output signal indicating a match condition
);

// Define states
parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;

reg [3:0] state, next_state;

// Output logic
always @(state) begin
    case(state)
        S0, S1, S2, S3, S4: MATCH = 1'b0;
        S5: MATCH = 1'b1;
        default: MATCH = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case(state)
        S0: begin
            if(IN) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if(!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if(!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if(IN) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if(IN) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if(IN) next_state = S5;
            else next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// State register
always @(posedge CLK or posedge RST) begin
    if(RST) state <= S0;
    else state <= next_state;
end

endmodule