module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [3:0] state, // Binary encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Define the states
parameter S = 4'd0;
parameter S1 = 4'd1;
parameter S11 = 4'd2;
parameter S110 = 4'd3;
parameter B0 = 4'd4;
parameter B1 = 4'd5;
parameter B2 = 4'd6;
parameter B3 = 4'd7;
parameter Count = 4'd8;
parameter Wait = 4'd9;

// Next-state logic
reg [3:0] next_state;

always @(*) begin
    case(state)
        S: next_state = (d) ? S1 : S;
        S1: next_state = (d) ? S11 : S;
        S11: next_state = (d) ? S11 : S110;
        S110: next_state = (d) ? B0 : S;
        B0: next_state = B1;
        B1: next_state = B2;
        B2: next_state = B3;
        B3: next_state = Count;
        Count: next_state = (done_counting) ? Wait : Count;
        Wait: next_state = (ack) ? S : Wait;
        default: next_state = S;
    endcase
end

assign B3_next = (next_state == B3);
assign S_next = (next_state == S);
assign S1_next = (next_state == S1);
assign Count_next = (next_state == Count);
assign Wait_next = (next_state == Wait);

// Output logic
assign shift_ena = (state == B0) || (state == B1) || (state == B2) || (state == B3);
assign counting = (state == Count);
assign done = (state == Wait);

endmodule