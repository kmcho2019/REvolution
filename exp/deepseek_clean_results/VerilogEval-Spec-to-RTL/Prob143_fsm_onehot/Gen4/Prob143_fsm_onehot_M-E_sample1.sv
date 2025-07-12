module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
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

// Transition LUT (current_state_idx x input -> next_state)
always @(*) begin
    next_state = 10'b0;
    case ({current_state_idx, in})
        // S0 transitions
        5'b0000_0: next_state[0] = 1'b1;
        5'b0000_1: next_state[1] = 1'b1;
        // S1 transitions
        5'b0001_0: next_state[0] = 1'b1;
        5'b0001_1: next_state[2] = 1'b1;
        // S2 transitions
        5'b0010_0: next_state[0] = 1'b1;
        5'b0010_1: next_state[3] = 1'b1;
        // S3 transitions
        5'b0011_0: next_state[0] = 1'b1;
        5'b0011_1: next_state[4] = 1'b1;
        // S4 transitions
        5'b0100_0: next_state[0] = 1'b1;
        5'b0100_1: next_state[5] = 1'b1;
        // S5 transitions
        5'b0101_0: next_state[8] = 1'b1;
        5'b0101_1: next_state[6] = 1'b1;
        // S6 transitions
        5'b0110_0: next_state[9] = 1'b1;
        5'b0110_1: next_state[7] = 1'b1;
        // S7 transitions
        5'b0111_0: next_state[0] = 1'b1;
        5'b0111_1: next_state[7] = 1'b1;
        // S8 transitions
        5'b1000_0: next_state[0] = 1'b1;
        5'b1000_1: next_state[1] = 1'b1;
        // S9 transitions
        5'b1001_0: next_state[0] = 1'b1;
        5'b1001_1: next_state[1] = 1'b1;
        default: next_state = 10'b0;
    endcase
end

// Output LUT - simple combinatorial logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

endmodule