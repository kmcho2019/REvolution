module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// Priority encoder to find highest priority active state
wire [3:0] current_state_num;
assign current_state_num = 
    state[9] ? 4'd9 :
    state[8] ? 4'd8 :
    state[7] ? 4'd7 :
    state[6] ? 4'd6 :
    state[5] ? 4'd5 :
    state[4] ? 4'd4 :
    state[3] ? 4'd3 :
    state[2] ? 4'd2 :
    state[1] ? 4'd1 :
    4'd0;

// Next state logic using compact encoding
always @(*) begin
    next_state = 10'b0;
    case (current_state_num)
        4'd0: next_state = in ? 10'b0000000010 : 10'b0000000001; // S0
        4'd1: next_state = in ? 10'b0000000100 : 10'b0000000001; // S1
        4'd2: next_state = in ? 10'b0000001000 : 10'b0000000001; // S2
        4'd3: next_state = in ? 10'b0000010000 : 10'b0000000001; // S3
        4'd4: next_state = in ? 10'b0000100000 : 10'b0000000001; // S4
        4'd5: next_state = in ? 10'b0001000000 : 10'b0100000000; // S5
        4'd6: next_state = in ? 10'b0010000000 : 10'b1000000000; // S6
        4'd7: next_state = in ? 10'b0010000000 : 10'b0000000001; // S7
        4'd8: next_state = in ? 10'b0000000010 : 10'b0000000001; // S8
        4'd9: next_state = in ? 10'b0000000010 : 10'b0000000001; // S9
        default: next_state = 10'b0000000001; // Default to S0
    endcase
end

// Output logic - independent of state transition logic
always @(*) begin
    out1 = (state[8] | state[9]); // S8 or S9
    out2 = (state[7] | state[9]); // S7 or S9
end

endmodule