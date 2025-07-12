module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0;

    // Initialize out1 and out2 to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // S0 (0, 0) --0--> S0
    // S0 (0, 0) --1--> S1
    if (state[0] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[1] = 1'b1;
        end
    end

    // S1 (0, 0) --0--> S0
    // S1 (0, 0) --1--> S2
    if (state[1] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[2] = 1'b1;
        end
    end

    // S2 (0, 0) --0--> S0
    // S2 (0, 0) --1--> S3
    if (state[2] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[3] = 1'b1;
        end
    end

    // S3 (0, 0) --0--> S0
    // S3 (0, 0) --1--> S4
    if (state[3] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[4] = 1'b1;
        end
    end

    // S4 (0, 0) --0--> S0
    // S4 (0, 0) --1--> S5
    if (state[4] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[5] = 1'b1;
        end
    end

    // S5 (0, 0) --0--> S8
    // S5 (0, 0) --1--> S6
    if (state[5] == 1'b1) begin
        if (!in) begin
            assign next_state[8] = 1'b1;
        end else begin
            assign next_state[6] = 1'b1;
        end
    end

    // S6 (0, 0) --0--> S9
    // S6 (0, 0) --1--> S7
    if (state[6] == 1'b1) begin
        if (!in) begin
            assign next_state[9] = 1'b1;
        end else begin
            assign next_state[7] = 1'b1;
        end
    end

    // S7 (0, 1) --0--> S0
    // S7 (0, 1) --1--> S7
    if (state[7] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[7] = 1'b1;
        end
        assign out2 = 1'b1;
    end

    // S8 (1, 0) --0--> S0
    // S8 (1, 0) --1--> S1
    if (state[8] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[1] = 1'b1;
        end
        assign out1 = 1'b1;
    end

    // S9 (1, 1) --0--> S0
    // S9 (1, 1) --1--> S1
    if (state[9] == 1'b1) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[1] = 1'b1;
        end
        assign out1 = 1'b1;
        assign out2 = 1'b1;
    end

endmodule