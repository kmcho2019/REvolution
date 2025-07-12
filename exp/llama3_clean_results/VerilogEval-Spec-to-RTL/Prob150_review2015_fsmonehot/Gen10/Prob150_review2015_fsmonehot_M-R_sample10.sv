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

    // Next-state logic using case statement
    reg B3_next, S_next, S1_next, Count_next, Wait_next;
    always @(*) begin
        case (1'b1)
            S: begin
                if (~d) begin
                    S_next = 1'b1;
                    S1_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b1;
                end
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
            S1: begin
                if (~d) begin
                    S_next = 1'b1;
                    S1_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                end
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
            S11: begin
                if (~d) begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                end
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
            S110: begin
                if (~d) begin
                    S_next = 1'b1;
                    S1_next = 1'b0;
                end else begin
                    S_next = 1'b0;
                    S1_next = 1'b0;
                end
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
            B0: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
            B1: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
            B2: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b1;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
            B3: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b0;
                Count_next = 1'b1;
                Wait_next = 1'b0;
            end
            Count: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b0;
                if (~done_counting) begin
                    Count_next = 1'b1;
                end else begin
                    Count_next = 1'b0;
                end
                if (done_counting) begin
                    Wait_next = 1'b1;
                end else begin
                    Wait_next = 1'b0;
                end
            end
            Wait: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b0;
                Count_next = 1'b0;
                if (ack) begin
                    S_next = 1'b1;
                    Wait_next = 1'b0;
                end else begin
                    Wait_next = 1'b1;
                end
            end
            default: begin
                S_next = 1'b0;
                S1_next = 1'b0;
                B3_next = 1'b0;
                Count_next = 1'b0;
                Wait_next = 1'b0;
            end
        endcase
    end

    // Output logic equations
    assign done = Wait;
    assign counting = Count;
    assign shift_ena = B0 || B1 || B2 || B3;

endmodule