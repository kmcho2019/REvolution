module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Mathematical state position calculation
wire [3:0] state_pos;
assign state_pos = 
    (state[0] ? 4'd0 : 4'd0) |
    (state[1] ? 4'd1 : 4'd0) |
    (state[2] ? 4'd2 : 4'd0) |
    (state[3] ? 4'd3 : 4'd0) |
    (state[4] ? 4'd4 : 4'd0) |
    (state[5] ? 4'd5 : 4'd0) |
    (state[6] ? 4'd6 : 4'd0) |
    (state[7] ? 4'd7 : 4'd0) |
    (state[8] ? 4'd8 : 4'd0) |
    (state[9] ? 4'd9 : 4'd0);

// Output logic based on mathematical properties
assign out1 = (state_pos >= 8);  // S8 or S9
assign out2 = (state_pos == 7 || state_pos == 9);  // S7 or S9

always @(*) begin
    next_state = 10'b0;
    
    // Mathematical transition logic
    case (1'b1)
        // S0-S4 progression
        (state_pos <= 4 && in): next_state[state_pos + 1] = 1'b1;
        
        // S0-S4 reset
        (state_pos <= 4 && ~in): next_state[0] = 1'b1;
        
        // S5 special cases
        (state_pos == 5 && in): next_state[6] = 1'b1;
        (state_pos == 5 && ~in): next_state[8] = 1'b1;
        
        // S6 special cases
        (state_pos == 6 && in): next_state[7] = 1'b1;
        (state_pos == 6 && ~in): next_state[9] = 1'b1;
        
        // S7 behavior
        (state_pos == 7 && in): next_state[7] = 1'b1;
        (state_pos == 7 && ~in): next_state[0] = 1'b1;
        
        // S8/S9 behavior (same as S0)
        (state_pos >= 8 && in): next_state[1] = 1'b1;
        (state_pos >= 8 && ~in): next_state[0] = 1'b1;
    endcase
end

endmodule