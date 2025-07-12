module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

reg [9:0] next_state_reg;
reg out1_reg;
reg out2_reg;

always @(*) begin
    next_state_reg = 10'b0;
    out1_reg = 1'b0;
    out2_reg = 1'b0;

    // S0
    if (state[0]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[1] = 1'b1;
        end
    end

    // S1
    if (state[1]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[2] = 1'b1;
        end
    end

    // S2
    if (state[2]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[3] = 1'b1;
        end
    end

    // S3
    if (state[3]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[4] = 1'b1;
        end
    end

    // S4
    if (state[4]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[5] = 1'b1;
        end
    end

    // S5
    if (state[5]) begin
        if (!in) begin
            next_state_reg[8] = 1'b1;
        end else begin
            next_state_reg[6] = 1'b1;
        end
    end

    // S6
    if (state[6]) begin
        if (!in) begin
            next_state_reg[9] = 1'b1;
        end else begin
            next_state_reg[7] = 1'b1;
        end
    end

    // S7
    if (state[7]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[7] = 1'b1;
            out1_reg = 1'b0;
            out2_reg = 1'b1;
        end
    end

    // S8
    if (state[8]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[1] = 1'b1;
        end
        out1_reg = 1'b1;
        out2_reg = 1'b0;
    end

    // S9
    if (state[9]) begin
        if (!in) begin
            next_state_reg[0] = 1'b1;
        end else begin
            next_state_reg[1] = 1'b1;
        end
        out1_reg = 1'b1;
        out2_reg = 1'b1;
    end

    next_state = next_state_reg;
    out1 = out1_reg;
    out2 = out2_reg;
end

endmodule