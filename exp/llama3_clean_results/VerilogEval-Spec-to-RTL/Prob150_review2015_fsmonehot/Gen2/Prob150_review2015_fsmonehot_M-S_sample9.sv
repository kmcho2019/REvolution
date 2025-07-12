module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

reg [9:0] nextState;
always @(*) begin
    case (1'b1)
        state[0]: nextState = (d)? 10'b0000000010 : 10'b0000000001; // S
        state[1]: nextState = (d)? 10'b0000000100 : 10'b0000000001; // S1
        state[2]: nextState = (d)? 10'b0000000100 : 10'b0000001000; // S11
        state[3]: nextState = (d)? 10'b0000100000 : 10'b0000000001; // S110
        state[4]: nextState = 10'b0001000000; // B0
        state[5]: nextState = 10'b0010000000; // B1
        state[6]: nextState = 10'b0100000000; // B2
        state[7]: nextState = 10'b1000000000; // B3
        state[8]: nextState = (done_counting)? 10'b1000000000 : 10'b1000000000; // Count
        state[9]: nextState = (ack)? 10'b0000000001 : 10'b1000000000; // Wait
        default: nextState = 10'b0000000001; // default state
    endcase
end

assign B3_next = nextState[7];
assign S_next = nextState[0];
assign S1_next = nextState[1];
assign Count_next = nextState[8];
assign Wait_next = nextState[9];

assign done = state[9];
assign counting = state[8];
assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule