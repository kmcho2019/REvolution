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

    // Next-state logic equations using a lookup table
    reg B3_next_reg, S_next_reg, S1_next_reg, S11_next_reg, S110_next_reg, Count_next_reg, Wait_next_reg, B0_next_reg, B1_next_reg, B2_next_reg;
    reg done_reg, counting_reg, shift_ena_reg;

    always @(*) begin
        // Default values
        B3_next_reg = 1'b0;
        S_next_reg = 1'b0;
        S1_next_reg = 1'b0;
        S11_next_reg = 1'b0;
        S110_next_reg = 1'b0;
        Count_next_reg = 1'b0;
        Wait_next_reg = 1'b0;
        B0_next_reg = 1'b0;
        B1_next_reg = 1'b0;
        B2_next_reg = 1'b0;
        done_reg = 1'b0;
        counting_reg = 1'b0;
        shift_ena_reg = 1'b0;

        // Lookup table
        if (S) begin
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                S1_next_reg = 1'b1;
            end
        end else if (S1) begin
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                S11_next_reg = 1'b1;
            end
        end else if (S11) begin
            if (~d) begin
                S110_next_reg = 1'b1;
            end else begin
                S11_next_reg = 1'b1;
            end
        end else if (S110) begin
            if (~d) begin
                S_next_reg = 1'b1;
            end else begin
                B0_next_reg = 1'b1;
            end
        end else if (B0) begin
            shift_ena_reg = 1'b1;
            B1_next_reg = 1'b1;
        end else if (B1) begin
            shift_ena_reg = 1'b1;
            B2_next_reg = 1'b1;
        end else if (B2) begin
            shift_ena_reg = 1'b1;
            B3_next_reg = 1'b1;
        end else if (B3) begin
            shift_ena_reg = 1'b1;
            Count_next_reg = 1'b1;
        end else if (Count) begin
            counting_reg = 1'b1;
            if (~done_counting) begin
                Count_next_reg = 1'b1;
            end else begin
                Wait_next_reg = 1'b1;
            end
        end else if (Wait) begin
            done_reg = 1'b1;
            if (~ack) begin
                Wait_next_reg = 1'b1;
            end else begin
                S_next_reg = 1'b1;
            end
        end
    end

    assign B3_next = B3_next_reg;
    assign S_next = S_next_reg;
    assign S1_next = S1_next_reg;
    assign Count_next = Count_next_reg;
    assign Wait_next = Wait_next_reg;
    assign done = done_reg;
    assign counting = counting_reg;
    assign shift_ena = shift_ena_reg;

endmodule