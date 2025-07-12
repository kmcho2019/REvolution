module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to select the highest priority active state
wire [3:0] current_state_idx;
assign current_state_idx = 
    state[0] ? 4'd0 :
    state[1] ? 4'd1 :
    state[2] ? 4'd2 :
    state[3] ? 4'd3 :
    state[4] ? 4'd4 :
    state[5] ? 4'd5 :
    state[6] ? 4'd6 :
    state[7] ? 4'd7 :
    state[8] ? 4'd8 :
    state[9] ? 4'd9 :
    4'd0;  // Default to S0 if no state is active (shouldn't happen in one-hot)

// Pre-calculate all possible next state transitions
wire [9:0] next_S0 = in ? 10'b0000000010 : 10'b0000000001;
wire [9:0] next_S1 = in ? 10'b0000000100 : 10'b0000000001;
wire [9:0] next_S2 = in ? 10'b0000001000 : 10'b0000000001;
wire [9:0] next_S3 = in ? 10'b0000010000 : 10'b0000000001;
wire [9:0] next_S4 = in ? 10'b0000100000 : 10'b0000000001;
wire [9:0] next_S5 = in ? 10'b0001000000 : 10'b0100000000;
wire [9:0] next_S6 = in ? 10'b0010000000 : 10'b1000000000;
wire [9:0] next_S7 = in ? 10'b0010000000 : 10'b0000000001;
wire [9:0] next_S8 = in ? 10'b0000000010 : 10'b0000000001;
wire [9:0] next_S9 = in ? 10'b0000000010 : 10'b0000000001;

// Select next state based on current state
always @(*) begin
    case (current_state_idx)
        4'd0: next_state = next_S0;
        4'd1: next_state = next_S1;
        4'd2: next_state = next_S2;
        4'd3: next_state = next_S3;
        4'd4: next_state = next_S4;
        4'd5: next_state = next_S5;
        4'd6: next_state = next_S6;
        4'd7: next_state = next_S7;
        4'd8: next_state = next_S8;
        4'd9: next_state = next_S9;
        default: next_state = 10'b0000000001; // Default to S0
    endcase
end

// Output generation using pattern matching
assign out1 = (current_state_idx == 4'd8) || (current_state_idx == 4'd9);
assign out2 = (current_state_idx == 4'd7) || (current_state_idx == 4'd9);

endmodule