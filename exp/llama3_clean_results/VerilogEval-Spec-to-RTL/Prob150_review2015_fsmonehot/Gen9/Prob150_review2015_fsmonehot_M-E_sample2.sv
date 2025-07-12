module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
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
    always @(*) begin
        B3_next = 0;
        S_next  = 0;
        S1_next = 0;
        Count_next = 0;
        Wait_next = 0;
        shift_ena = 0;
        counting = 0;
        done = 0;

        if (S) begin
            if (~d) begin
                S_next = 1;
            end else begin
                S1_next = 1;
            end
        end else if (S1) begin
            if (~d) begin
                S_next = 1;
            end else begin
                S11_next = 1;
            end
        end else if (S11) begin
            if (~d) begin
                S110_next = 1;
            end else begin
                S11_next = 1;
            end
        end else if (S110) begin
            if (~d) begin
                S_next = 1;
            end else begin
                B0_next = 1;
            end
        end else if (B0) begin
            B1_next = 1;
            shift_ena = 1;
        end else if (B1) begin
            B2_next = 1;
            shift_ena = 1;
        end else if (B2) begin
            B3_next = 1;
            shift_ena = 1;
        end else if (B3) begin
            Count_next = 1;
            shift_ena = 1;
        end else if (Count) begin
            if (~done_counting) begin
                Count_next = 1;
                counting = 1;
            end else begin
                Wait_next = 1;
                counting = 1;
            end
        end else if (Wait) begin
            if (~ack) begin
                Wait_next = 1;
                done = 1;
            end else begin
                S_next = 1;
                done = 1;
            end
        end
    end

    // Output logic equations using LUT approach
    always @(*) begin
        if (B0 || B1 || B2 || B3) begin
            shift_ena = 1;
        end

        if (Count) begin
            counting = 1;
        end

        if (Wait) begin
            done = 1;
        end
    end

endmodule