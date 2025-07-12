module fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

// Simplified state encoding
parameter IDLE  = 2'b00;
parameter S1    = 2'b01;
parameter S10   = 2'b10;
parameter S100  = 2'b11;
parameter S1001 = 3'b100; // Only 3rd bit needed for this state

reg [2:0] current_state, next_state;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        // Mealy output
        MATCH <= (current_state == S1001 && IN == 1'b1);
    end
end

// Simplified next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = IN ? S1 : IDLE;
        S1:   next_state = IN ? S1 : S10;
        S10:  next_state = IN ? S1 : S100;
        S100: next_state = IN ? S1001 : IDLE;
        S1001: begin
            if (IN) next_state = S1; // Match complete, start new sequence
            else next_state = S10;   // Partial overlap "1001" + "0"
        end
        default: next_state = IDLE;
    endcase
end

endmodule