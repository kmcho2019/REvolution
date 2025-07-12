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

// Next-state logic
always @(*) begin
    case(state)
        10'b0000000001: // S
            if(d == 0) begin
                S_next = 1;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end else begin
                S_next = 0;
                S1_next = 1;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
        10'b0000000010: // S1
            if(d == 0) begin
                S_next = 1;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end else begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
                // Transition to S11 not handled explicitly
            end
        10'b0000000100: // S11
            if(d == 0) begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
                // Transition to S110 not handled explicitly
            end else begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
        10'b0000001000: // S110
            if(d == 0) begin
                S_next = 1;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end else begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
                // Transition to B0 not handled explicitly
            end
        10'b0000010000: // B0
            begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
                // Transition to B1 not handled explicitly
            end
        10'b0000100000: // B1
            begin
                S_next = 0;
                S1_next = 0;
                B3_next = 1;
                Count_next = 0;
                Wait_next = 0;
            end
        10'b0001000000: // B2
            begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
                // Transition to B3 not handled explicitly
            end
        10'b0010000000: // B3
            begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 1;
                Wait_next = 0;
            end
        10'b0100000000: // Count
            if(done_counting == 0) begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 1;
                Wait_next = 0;
            end else begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 1;
            end
        10'b1000000000: // Wait
            if(ack == 0) begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 1;
            end else begin
                S_next = 1;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
        default:
            begin
                S_next = 0;
                S1_next = 0;
                B3_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
    endcase
end

// Output logic
assign shift_ena = state[5] | state[6] | state[7] | state[8];
assign counting = state[9];
assign done = state[9] | state[10];

endmodule