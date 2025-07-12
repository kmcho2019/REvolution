module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Define state machine states
parameter S = 10'b0000000001;
parameter S1 = 10'b0000000010;
parameter S11 = 10'b0000000100;
parameter S110 = 10'b0000001000;
parameter B0 = 10'b0000010000;
parameter B1 = 10'b0000100000;
parameter B2 = 10'b0001000000;
parameter B3 = 10'b0010000000;
parameter Count = 10'b0100000000;
parameter Wait = 10'b1000000000;

// Next state logic
wire [9:0] next_state;
always @(*) begin
    case (state)
        S: next_state = d? S1 : S;
        S1: next_state = d? S11 : S;
        S11: next_state = d? S11 : S110;
        S110: next_state = d? B0 : S;
        B0: next_state = B1;
        B1: next_state = B2;
        B2: next_state = B3;
        B3: next_state = Count;
        Count: next_state = done_counting? Wait : Count;
        Wait: next_state = ack? S : Wait;
        default: next_state = S;
    endcase
end

// Output logic
assign B3_next = next_state == B3;
assign S_next = next_state == S;
assign S1_next = next_state == S1;
assign Count_next = next_state == Count;
assign Wait_next = next_state == Wait;

assign shift_ena = (state == B0) || (state == B1) || (state == B2) || (state == B3);
assign counting = (state == Count);
assign done = (state == Wait);

endmodule