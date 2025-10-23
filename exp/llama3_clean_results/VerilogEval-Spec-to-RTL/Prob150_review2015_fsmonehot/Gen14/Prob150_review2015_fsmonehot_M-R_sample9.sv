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

    // Next-state logic
    always @(*) begin
        case (1'b1)
            S:     B3_next = 1'b0; S_next = (~d); S1_next = d; Count_next = 1'b0; Wait_next = 1'b0;
            S1:    B3_next = 1'b0; S_next = (~d); S1_next = 1'b0; Count_next = 1'b0; Wait_next = 1'b0;
            S11:   B3_next = 1'b0; S_next = 1'b0; S1_next = 1'b0; Count_next = 1'b0; Wait_next = 1'b0;
            S110:  B3_next = d; S_next = (~d); S1_next = 1'b0; Count_next = 1'b0; Wait_next = 1'b0;
            B0:    B3_next = 1'b0; S_next = 1'b0; S1_next = 1'b0; Count_next = 1'b0; Wait_next = 1'b0;
            B1:    B3_next = 1'b0; S_next = 1'b0; S1_next = 1'b0; Count_next = 1'b0; Wait_next = 1'b0;
            B2:    B3_next = 1'b1; S_next = 1'b0; S1_next = 1'b0; Count_next = 1'b0; Wait_next = 1'b0;
            B3:    B3_next = 1'b0; S_next = 1'b0; S1_next = 1'b0; Count_next = 1'b1; Wait_next = 1'b0;
            Count: B3_next = 1'b0; S_next = 1'b0; S1_next = 1'b0; Count_next = (~done_counting); Wait_next = done_counting;
            Wait:  B3_next = 1'b0; S_next = ack; S1_next = 1'b0; Count_next = 1'b0; Wait_next = (~ack);
            default: B3_next = 1'b0; S_next = 1'b0; S1_next = 1'b0; Count_next = 1'b0; Wait_next = 1'b0;
        endcase
    end

    // Output logic
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = (B0 || B1 || B2 || B3);

endmodule