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

// Define next-state logic
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
        default: next_state = 10'b0000000001; // S
    endcase
end

assign B3_next = (next_state == 10'b0010000000); // B3
assign S_next = (next_state == 10'b0000000001); // S
assign S1_next = (next_state == 10'b0000000010); // S1
assign Count_next = (next_state == 10'b0100000000); // Count
assign Wait_next = (next_state == 10'b1000000000); // Wait

// Define output logic
always @(*) begin
    case (state)
        10'b0000010000, // B0
        10'b0000100000, // B1
        10'b0001000000, // B2
        10'b0010000000: // B3
            shift_ena = 1'b1;
        default:
            shift_ena = 1'b0;
    endcase
end

always @(*) begin
    case (state)
        10'b0100000000: // Count
            counting = 1'b1;
        default:
            counting = 1'b0;
    endcase
end

always @(*) begin
    case (state)
        10'b1000000000: // Wait
            done = 1'b1;
        default:
            done = 1'b0;
    endcase
end

endmodule