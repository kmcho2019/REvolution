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

    // Next-state logic equations using LUT approach
    assign B3_next = (B2);
    assign S_next  = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack);
    assign S1_next = (S && d) || (S1 && ~d) || (S11 && ~d);
    assign Count_next = (B3) || (Count && ~done_counting);
    assign Wait_next = (Count && done_counting) || (Wait && ~ack);

    // Output logic equations using LUT approach
    always @(*) begin
        case ({B0, B1, B2, B3, Count, Wait})
            5'b000001: shift_ena = 1'b0; counting = 1'b1; done = 1'b0;
            5'b000010: shift_ena = 1'b1; counting = 1'b1; done = 1'b0;
            5'b000100: shift_ena = 1'b1; counting = 1'b1; done = 1'b0;
            5'b001000: shift_ena = 1'b1; counting = 1'b1; done = 1'b0;
            5'b010000: shift_ena = 1'b1; counting = 1'b1; done = 1'b0;
            5'b100000: shift_ena = 1'b0; counting = 1'b0; done = 1'b1;
            default: shift_ena = 1'b0; counting = 1'b0; done = 1'b0;
        endcase
    end

endmodule