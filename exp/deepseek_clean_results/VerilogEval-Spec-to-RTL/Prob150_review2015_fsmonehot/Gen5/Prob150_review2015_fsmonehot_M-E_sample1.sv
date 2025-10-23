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

    // State bit aliases with priority encoding
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

    // Intermediate next-state signals
    wire next_S, next_S1, next_S11, next_S110, next_B0, next_B1, next_B2, next_B3, next_Count, next_Wait;

    // Priority-encoded next-state logic
    assign next_S = (Wait & ack) ||                   // Highest priority
                   (S & ~d) || (S1 & ~d) || (S110 & ~d);

    assign next_S1 = !next_S && (S & d);

    assign next_S11 = !next_S && !next_S1 && (S1 & d);

    assign next_S110 = !next_S && !next_S1 && !next_S11 && (S11 & ~d);

    assign next_B0 = !next_S && !next_S1 && !next_S11 && !next_S110 && (S110 & d);

    assign next_B1 = B0;
    assign next_B2 = B1;
    assign next_B3 = B2;

    assign next_Count = B3 || (Count & ~done_counting);

    assign next_Wait = Count & done_counting;

    // Output next-state signals
    assign S_next = next_S;
    assign S1_next = next_S1;
    assign B3_next = next_B3;
    assign Count_next = next_Count;
    assign Wait_next = next_Wait;

    // Output generation with pipelining
    reg done_r, counting_r, shift_ena_r;
    always @(*) begin
        done_r = Wait;
        counting_r = Count;
        shift_ena_r = B0 | B1 | B2 | B3;
    end

    assign done = done_r;
    assign counting = counting_r;
    assign shift_ena = shift_ena_r;

endmodule