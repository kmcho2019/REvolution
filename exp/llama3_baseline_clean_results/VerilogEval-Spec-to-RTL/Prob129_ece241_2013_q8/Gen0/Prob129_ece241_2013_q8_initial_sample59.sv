module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // Current state (2 bits for 3 states: S0, S1, S2)
reg [1:0] nextState; // Next state

// Output z is asserted when the sequence "101" is detected
assign z = (state == 2'b10 && x == 1'b1);

// State machine transitions
always @(*) begin
    case(state)
        2'b00: // S0: Waiting for a "1"
            if(x == 1'b1) 
                nextState = 2'b01; // Go to S1 if a "1" is detected
            else 
                nextState = 2'b00; // Stay in S0 if not a "1"
        2'b01: // S1: Waiting for a "0"
            if(x == 1'b0) 
                nextState = 2'b10; // Go to S2 if a "0" is detected
            else if(x == 1'b1) 
                nextState = 2'b01; // Stay in S1 if another "1" is detected
            else 
                nextState = 2'b01; // Shouldn't happen, but default to S1
        2'b10: // S2: Waiting for another "1"
            if(x == 1'b1) 
                nextState = 2'b10; // Stay in S2 and assert output z if another "1" is detected
            else 
                nextState = 2'b01; // Go back to S1 if not a "1"
        default: // Shouldn't happen
            nextState = 2'b00;
    endcase
end

// Sequential logic
always @(posedge clk or negedge aresetn) begin
    if(!aresetn) 
        state <= 2'b00; // Reset to S0 on negative edge of aresetn
    else 
        state <= nextState;
end

endmodule