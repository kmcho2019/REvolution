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
            if (d == 1'b0) next_state = 10'b0000000001; // S
            else next_state = 10'b0000000010; // S1
        10'b0000000010: // S1
            if (d == 1'b0) next_state = 10'b0000000001; // S
            else next_state = 10'b0000000100; // S11
        10'b0000000100: // S11
            if (d == 1'b0) next_state = 10'b0000001000; // S110
            else next_state = 10'b0000000100; // S11
        10'b0000001000: // S110
            if (d == 1'b0) next_state = 10'b0000000001; // S
            else next_state = 10'b0000010000; // B0
        10'b0000010000: // B0
            next_state = 10'b0000100000; // B1
        10'b0000100000: // B1
            next_state = 10'b0001000000; // B2
        10'b0001000000: // B2
            next_state = 10'b0010000000; // B3
        10'b0010000000: // B3
            next_state = 10'b0100000000; // Count
        10'b0100000000: // Count
            if (done_counting == 1'b0) next_state = 10'b0100000000; // Count
            else next_state = 10'b1000000000; // Wait
        10'b1000000000: // Wait
            if (ack == 1'b0) next_state = 10'b1000000000; // Wait
            else next_state = 10'b0000000001; // S
    endcase
    
    // Determine next-state signals
    B3_next = (next_state == 10'b0010000000); // B3
    S_next = (next_state == 10'b0000000001); // S
    S1_next = (next_state == 10'b0000000010); // S1
    Count_next = (next_state == 10'b0100000000); // Count
    Wait_next = (next_state == 10'b1000000000); // Wait
    
    // Determine output signals
    case (state)
        10'b0000010000, // B0
        10'b0000100000, // B1
        10'b0001000000, // B2
        10'b0010000000: // B3
            shift_ena = 1'b1;
        default:
            shift_ena = 1'b0;
    endcase
    
    case (state)
        10'b0100000000: // Count
            counting = 1'b1;
        default:
            counting = 1'b0;
    endcase
    
    case (state)
        10'b1000000000: // Wait
            done = 1'b1;
        default:
            done = 1'b0;
    endcase
end

endmodule