module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // State register (3 bits for 6 states: S0 to S5)
wire match_condition; // Condition for setting MATCH to 1

// Define the match condition (at state S5)
assign match_condition = (state == 3'b101); // S5 (5th state, 10011 sequence)

// FSM state transitions
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset to initial state (S0)
    end else begin
        case(state)
            3'b000: // S0
                if(IN) state <= 3'b001; // Transition to S1 on input 1
                else state <= 3'b000; // Stay in S0 on input 0
            3'b001: // S1
                if(!IN) state <= 3'b010; // Transition to S2 on input 0
                else state <= 3'b000; // Reset to S0 on unexpected input 1
            3'b010: // S2
                if(!IN) state <= 3'b011; // Transition to S3 on input 0
                else state <= 3'b000; // Reset to S0 on unexpected input 1
            3'b011: // S3
                if(IN) state <= 3'b100; // Transition to S4 on input 1
                else state <= 3'b000; // Reset to S0 on unexpected input 0
            3'b100: // S4
                if(IN) state <= 3'b101; // Transition to S5 on input 1
                else state <= 3'b000; // Reset to S0 on unexpected input 0
            3'b101: // S5
                state <= 3'b000; // Reset to S0 after detecting the sequence
            default:
                state <= 3'b000; // Default: reset to S0
        endcase
    end
end

// Set MATCH to 1 when the match condition is met
always @(posedge CLK) begin
    if(match_condition) begin
        MATCH <= 1'b1;
    end else begin
        MATCH <= 1'b0;
    end
end

endmodule