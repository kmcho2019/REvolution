module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to find highest active state
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

// Next state calculation
always @(*) begin
    next_state = 10'b0;
    
    case (current_state_idx)
        0: next_state = in ? 10'b0000000010 : 10'b0000000001;  // S0
        1: next_state = in ? 10'b0000000100 : 10'b0000000001;  // S1
        2: next_state = in ? 10'b0000001000 : 10'b0000000001;  // S2
        3: next_state = in ? 10'b0000010000 : 10'b0000000001;  // S3
        4: next_state = in ? 10'b0000100000 : 10'b0000000001;  // S4
        5: next_state = in ? 10'b0001000000 : 10'b0010000000;  // S5
        6: next_state = in ? 10'b0100000000 : 10'b1000000000;  // S6
        7: next_state = in ? 10'b0100000000 : 10'b0000000001;  // S7
        8,9: next_state = in ? 10'b0000000010 : 10'b0000000001; // S8,S9
        default: next_state = 10'b0000000001;
    endcase
end

// Output generation using pattern matching
assign out1 = (state & 10'b0110000000) != 0;  // S8 or S9
assign out2 = (state & 10'b0101000000) != 0;  // S7 or S9

endmodule