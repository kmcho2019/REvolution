module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

reg [9:0] next_state;

always @(*) begin
    case (state)
        10'b0000000001: // S
            next_state = d? 10'b0000000010 : 10'b0000000001;
        10'b0000000010: // S1
            next_state = d? 10'b0000000100 : 10'b0000000001;
        10'b0000000100: // S11
            next_state = d? 10'b0000000100 : 10'b0000001000;
        10'b0000001000: // S110
            next_state = d? 10'b0000010000 : 10'b0000000001;
        10'b0000010000: // B0
            next_state = 10'b0000100000;
        10'b0000100000: // B1
            next_state = 10'b0001000000;
        10'b0001000000: // B2
            next_state = 10'b0010000000;
        10'b0010000000: // B3
            next_state = 10'b0100000000;
        10'b0100000000: // Count
            next_state = done_counting? 10'b1000000000 : 10'b0100000000;
        10'b1000000000: // Wait
            next_state = ack? 10'b0000000001 : 10'b1000000000;
    endcase
    
    // Determine next-state signals
    B3_next = (next_state == 10'b0010000000);
    S_next = (next_state == 10'b0000000001);
    S1_next = (next_state == 10'b0000000010);
    Count_next = (next_state == 10'b0100000000);
    Wait_next = (next_state == 10'b1000000000);
    
    // Determine output signals
    shift_ena = (state == 10'b0000010000) || (state == 10'b0000100000) || (state == 10'b0001000000) || (state == 10'b0010000000);
    counting = (state == 10'b0100000000);
    done = (state == 10'b1000000000);
end

endmodule