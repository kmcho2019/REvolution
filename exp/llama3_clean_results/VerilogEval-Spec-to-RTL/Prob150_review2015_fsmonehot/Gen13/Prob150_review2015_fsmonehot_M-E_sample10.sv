module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state
    wire S     = state[0];
    wire S1    = state[1];
    wire S11   = state[2];
    wire S110  = state[3];
    wire B0    = state[4];
    wire B1    = state[5];
    wire B2    = state[6];
    wire B3    = state[7];
    wire Count = state[8];
    wire Wait  = state[9];

    // LUT for next-state logic
    wire [9:0] next_state;
    always @(*) begin
        case ({S, S1, S11, S110, B0, B1, B2, B3, Count, Wait})
            10'b0000000001: next_state = (d) ? 10'b0000000010 : 10'b0000000001; // S
            10'b0000000010: next_state = (d) ? 10'b0000000100 : 10'b0000000001; // S1
            10'b0000000100: next_state = (d) ? 10'b0000000100 : 10'b0000001000; // S11
            10'b0000001000: next_state = (d) ? 10'b0000010000 : 10'b0000000001; // S110
            10'b0000010000: next_state = 10'b0000100000; // B0
            10'b0000100000: next_state = 10'b0001000000; // B1
            10'b0001000000: next_state = 10'b0010000000; // B2
            10'b0010000000: next_state = 10'b0100000000; // B3
            10'b0100000000: next_state = (done_counting) ? 10'b1000000000 : 10'b0100000000; // Count
            10'b1000000000: next_state = (ack) ? 10'b0000000001 : 10'b1000000000; // Wait
            default: next_state = 10'b0000000001; // default to S
        endcase
    end

    // Next-state logic equations
    assign B3_next = next_state[7];
    assign S_next = next_state[0];
    assign S1_next = next_state[1];
    assign Count_next = next_state[8];
    assign Wait_next = next_state[9];

    // Output logic equations
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule