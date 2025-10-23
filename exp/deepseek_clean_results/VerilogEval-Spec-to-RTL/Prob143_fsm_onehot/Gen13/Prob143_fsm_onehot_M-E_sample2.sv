module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Internal state representation
wire [2:0] current_state_num;
wire [6:0] base_states = state[6:0];
wire [2:0] output_states = state[9:7];

// Priority encoder for S0-S6
assign current_state_num = 
    state[6] ? 3'd6 :
    state[5] ? 3'd5 :
    state[4] ? 3'd4 :
    state[3] ? 3'd3 :
    state[2] ? 3'd2 :
    state[1] ? 3'd1 : 3'd0;

// State transition logic
always @(*) begin
    next_state = 10'b0;
    
    // Handle base states (S0-S6)
    if (|base_states) begin
        if (in) begin
            case (current_state_num)
                3'd0: next_state[1] = 1'b1;
                3'd1: next_state[2] = 1'b1;
                3'd2: next_state[3] = 1'b1;
                3'd3: next_state[4] = 1'b1;
                3'd4: next_state[5] = 1'b1;
                3'd5: next_state[6] = 1'b1;
                3'd6: next_state[7] = 1'b1;
            endcase
        end else begin
            case (current_state_num)
                3'd5: next_state[8] = 1'b1;
                3'd6: next_state[9] = 1'b1;
                default: next_state[0] = 1'b1;
            endcase
        end
    end
    
    // Handle output states (S7-S9)
    if (output_states[0]) next_state[in ? 7 : 0] = 1'b1; // S7
    if (output_states[1]) next_state[in ? 1 : 0] = 1'b1; // S8
    if (output_states[2]) next_state[in ? 1 : 0] = 1'b1; // S9
end

// Output logic - pattern matched
assign out1 = state[8] | state[9];  // Pattern 1x for out1
assign out2 = state[7] | state[9];  // Pattern x1 for out2

endmodule