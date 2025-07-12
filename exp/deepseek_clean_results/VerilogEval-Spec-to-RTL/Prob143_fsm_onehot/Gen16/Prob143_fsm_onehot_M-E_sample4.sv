module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to find highest priority active state
wire [3:0] current_state_idx;
assign current_state_idx = 
    state[9] ? 4'd9 :
    state[8] ? 4'd8 :
    state[7] ? 4'd7 :
    state[6] ? 4'd6 :
    state[5] ? 4'd5 :
    state[4] ? 4'd4 :
    state[3] ? 4'd3 :
    state[2] ? 4'd2 :
    state[1] ? 4'd1 : 4'd0;

// Output generation (parallel with state logic)
assign out1 = state[8] | state[9];  // S8 or S9 active
assign out2 = state[7] | state[9];  // S7 or S9 active

// State transition matrix
reg [9:0] next_state_reg;
always @(*) begin
    next_state_reg = 10'b0;
    
    case (current_state_idx)
        4'd0: begin // S0
            next_state_reg[0] = ~in;
            next_state_reg[1] = in;
        end
        4'd1: begin // S1
            next_state_reg[0] = ~in;
            next_state_reg[2] = in;
        end
        4'd2: begin // S2
            next_state_reg[0] = ~in;
            next_state_reg[3] = in;
        end
        4'd3: begin // S3
            next_state_reg[0] = ~in;
            next_state_reg[4] = in;
        end
        4'd4: begin // S4
            next_state_reg[0] = ~in;
            next_state_reg[5] = in;
        end
        4'd5: begin // S5
            next_state_reg[8] = ~in;
            next_state_reg[6] = in;
        end
        4'd6: begin // S6
            next_state_reg[9] = ~in;
            next_state_reg[7] = in;
        end
        4'd7: begin // S7
            next_state_reg[0] = ~in;
            next_state_reg[7] = in;
        end
        4'd8: begin // S8
            next_state_reg[0] = ~in;
            next_state_reg[1] = in;
        end
        4'd9: begin // S9
            next_state_reg[0] = ~in;
            next_state_reg[1] = in;
        end
        default: next_state_reg = 10'b0;
    endcase
end

assign next_state = next_state_reg;

endmodule