module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // 3-bit variable to store the current state (0 to 5)
reg match_reg; // Register to store the MATCH signal

// FSM logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset state to 0
        match_reg <= 1'b0; // Reset MATCH signal
    end else begin
        case(state)
            3'b000: // State 0
                if(IN) state <= 3'b001; // If input is 1, move to state 1
                else state <= 3'b000; // Otherwise, stay in state 0
            3'b001: // State 1
                if(!IN) state <= 3'b010; // If input is 0, move to state 2
                else state <= 3'b000; // Otherwise, reset to state 0
            3'b010: // State 2
                if(!IN) state <= 3'b011; // If input is 0, move to state 3
                else state <= 3'b000; // Otherwise, reset to state 0
            3'b011: // State 3
                if(IN) state <= 3'b100; // If input is 1, move to state 4
                else state <= 3'b000; // Otherwise, reset to state 0
            3'b100: // State 4
                if(IN) state <= 3'b100; // If input is 1, stay in state 4 and set MATCH signal
                else state <= 3'b000; // Otherwise, reset to state 0
            default: state <= 3'b000; // Default case
        endcase
        if(state == 3'b100 && IN) match_reg <= 1'b1; // Set MATCH signal when in state 4 and input is 1
        else match_reg <= 1'b0; // Otherwise, reset MATCH signal
    end
end

assign MATCH = match_reg; // Assign MATCH signal

endmodule