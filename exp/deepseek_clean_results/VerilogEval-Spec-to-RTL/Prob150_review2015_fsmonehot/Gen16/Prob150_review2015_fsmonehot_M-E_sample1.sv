module TopModule (
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

    // Priority encoder for current state
    wire [3:0] curr_state_enc;
    assign curr_state_enc = 
        state[9] ? 4'd9 :  // Wait
        state[8] ? 4'd8 :  // Count
        state[7] ? 4'd7 :  // B3
        state[6] ? 4'd6 :  // B2
        state[5] ? 4'd5 :  // B1
        state[4] ? 4'd4 :  // B0
        state[3] ? 4'd3 :  // S110
        state[2] ? 4'd2 :  // S11
        state[1] ? 4'd1 :  // S1
        4'd0;              // S

    // Next state logic
    reg [9:0] next_state;
    always @(*) begin
        case (curr_state_enc)
            4'd0: next_state = d ? 10'b0000000010 : 10'b0000000001;  // S -> S1 or S
            4'd1: next_state = d ? 10'b0000000100 : 10'b0000000001;  // S1 -> S11 or S
            4'd2: next_state = d ? 10'b0000000100 : 10'b0000001000; // S11 -> S11 or S110
            4'd3: next_state = d ? 10'b0000010000 : 10'b0000000001; // S110 -> B0 or S
            4'd4: next_state = 10'b0000100000;                      // B0 -> B1
            4'd5: next_state = 10'b0001000000;                      // B1 -> B2
            4'd6: next_state = 10'b0010000000;                      // B2 -> B3
            4'd7: next_state = 10'b0100000000;                      // B3 -> Count
            4'd8: next_state = done_counting ? 10'b1000000000 : 10'b0100000000; // Count -> Wait or Count
            4'd9: next_state = ack ? 10'b0000000001 : 10'b1000000000; // Wait -> S or Wait
            default: next_state = 10'b0000000001;                   // Default to S
        endcase
    end

    // Next state indicators
    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    // Output logic
    assign shift_ena = (curr_state_enc >= 4'd4) && (curr_state_enc <= 4'd7);
    assign counting = (curr_state_enc == 4'd8);
    assign done = (curr_state_enc == 4'd9);

endmodule