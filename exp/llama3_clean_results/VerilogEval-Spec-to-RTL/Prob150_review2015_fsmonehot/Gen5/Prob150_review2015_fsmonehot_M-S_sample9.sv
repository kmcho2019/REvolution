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

always @(*) begin
    B3_next = 1'b0;
    S_next = 1'b0;
    S1_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;
    done = 1'b0;
    counting = 1'b0;
    shift_ena = 1'b0;

    case (state)
        S: {S_next, S1_next} = {~d, d};
        S1: {S_next, S1_next} = {~d, d};
        S11: {S_next, S1_next, Count_next} = {~d, d, 1'b0};
        S110: {S_next, B3_next} = {~d, d};
        B0: begin
            B3_next = 1'b0;
            S_next = 1'b0;
            S1_next = 1'b0;
            Count_next = 1'b0;
            Wait_next = 1'b0;
            shift_ena = 1'b1;
        end
        B1: {B3_next, shift_ena} = {1'b0, 1'b1};
        B2: {B3_next, shift_ena} = {1'b1, 1'b1};
        B3: {B3_next, Count_next, shift_ena} = {1'b0, 1'b1, 1'b1};
        Count: begin
            {Count_next, Wait_next, counting} = {~done_counting, done_counting, 1'b1};
        end
        Wait: begin
            {S_next, Wait_next, done} = {ack, ~ack, 1'b1};
        end
    endcase
end

endmodule