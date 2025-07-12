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

    // Current state signals (one-hot)
    wire S_curr    = state[0];
    wire S1_curr   = state[1];
    wire S11_curr  = state[2];
    wire S110_curr = state[3];
    wire B0_curr   = state[4];
    wire B1_curr   = state[5];
    wire B2_curr   = state[6];
    wire B3_curr   = state[7];
    wire Count_curr= state[8];
    wire Wait_curr = state[9];

    // Next state signals
    reg [9:0] next_state;
    assign S_next    = next_state[0];
    assign S1_next   = next_state[1];
    assign B3_next   = next_state[7];
    assign Count_next= next_state[8];
    assign Wait_next = next_state[9];

    // State transition logic
    always @(*) begin
        next_state = 10'b0;  // Default to all zeros
        
        case (1'b1)  // Synthesis will optimize this to parallel case
            S_curr:     next_state = d ? 10'b0000000010 : 10'b0000000001;
            S1_curr:    next_state = d ? 10'b0000000100 : 10'b0000000001;
            S11_curr:   next_state = d ? 10'b0000000100 : 10'b0000001000;
            S110_curr:  next_state = d ? 10'b0000010000 : 10'b0000000001;
            B0_curr:    next_state = 10'b0000100000;
            B1_curr:    next_state = 10'b0001000000;
            B2_curr:    next_state = 10'b0010000000;
            B3_curr:    next_state = 10'b0100000000;
            Count_curr: next_state = done_counting ? 10'b1000000000 : 10'b0100000000;
            Wait_curr:  next_state = ack ? 10'b0000000001 : 10'b1000000000;
            default:    next_state = 10'b0000000001;  // Default to S state
        endcase
    end

    // Output logic
    assign shift_ena = B0_curr | B1_curr | B2_curr | B3_curr;
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule