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
    reg B3_next_reg, S_next_reg, S1_next_reg, Count_next_reg, Wait_next_reg;
    always @(*) begin
        case (1'b1)
            S: begin
                if (~d) B3_next_reg = 0; else B3_next_reg = 0;
                S_next_reg = ~d;
                S1_next_reg = d;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            S1: begin
                if (~d) B3_next_reg = 0; else B3_next_reg = 0;
                S_next_reg = ~d;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            S11: begin
                if (~d) B3_next_reg = 0; else B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            S110: begin
                if (~d) B3_next_reg = 0; else B3_next_reg = 0;
                S_next_reg = ~d;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            B0: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            B1: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            B2: begin
                B3_next_reg = 1;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
            B3: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 1;
                Wait_next_reg = 0;
            end
            Count: begin
                if (~done_counting) B3_next_reg = 0; else B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = ~done_counting;
                Wait_next_reg = done_counting;
            end
            Wait: begin
                if (ack) B3_next_reg = 0; else B3_next_reg = 0;
                S_next_reg = ack;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = ~ack;
            end
            default: begin
                B3_next_reg = 0;
                S_next_reg = 0;
                S1_next_reg = 0;
                Count_next_reg = 0;
                Wait_next_reg = 0;
            end
        endcase
    end

    assign B3_next = B3_next_reg;
    assign S_next = S_next_reg;
    assign S1_next = S1_next_reg;
    assign Count_next = Count_next_reg;
    assign Wait_next = Wait_next_reg;

    // Output logic equations
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule