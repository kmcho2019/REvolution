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

    // Next-state logic equations
    assign B3_next  = (B2);
    assign S_next   = (S && ~d) || (S1 && ~d) || (S110 && ~d) || (Wait && ack);
    assign S1_next  = (S && d) || (S1 && ~d) || (S11 && ~d);
    assign Count_next = (B3) || (Count && ~done_counting);
    assign Wait_next = (Count && done_counting) || (Wait && ~ack);

    // Output logic equations
    assign shift_ena = B0 || B1 || B2 || B3;
    assign counting  = Count;
    assign done      = Wait;

    // Alternative implementation using case statement
    // reg [9:0] next_state;
    // always @(*) begin
    //     case (1'b1)
    //         S: next_state = (d)? 10'b0000000010 : 10'b0000000001;
    //         S1: next_state = (d)? 10'b0000000100 : 10'b0000000001;
    //         S11: next_state = (d)? 10'b0000000100 : 10'b0000000010;
    //         S110: next_state = (d)? 10'b0000000100 : 10'b0000000001;
    //         B0: next_state = 10'b0000001000;
    //         B1: next_state = 10'b0000010000;
    //         B2: next_state = 10'b0000100000;
    //         B3: next_state = 10'b0001000000;
    //         Count: next_state = (done_counting)? 10'b0010000000 : 10'b0001000000;
    //         Wait: next_state = (ack)? 10'b0000000001 : 10'b0010000000;
    //         default: next_state = 10'b0000000001;
    //     endcase
    // end

    // assign B3_next  = next_state[7];
    // assign S_next   = next_state[0];
    // assign S1_next  = next_state[1];
    // assign Count_next = next_state[8];
    // assign Wait_next = next_state[9];

endmodule