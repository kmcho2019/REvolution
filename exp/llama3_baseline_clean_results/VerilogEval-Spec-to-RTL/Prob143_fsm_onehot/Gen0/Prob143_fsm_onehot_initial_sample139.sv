module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    next_state = 10'b0;
    out1 = 0;
    out2 = 0;

    if (state[0]) begin // S0
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[1] = 1; // S1
        end
    end

    if (state[1]) begin // S1
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[2] = 1; // S2
        end
    end

    if (state[2]) begin // S2
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[3] = 1; // S3
        end
    end

    if (state[3]) begin // S3
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[4] = 1; // S4
        end
    end

    if (state[4]) begin // S4
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[5] = 1; // S5
        end
    end

    if (state[5]) begin // S5
        if (!in) begin
            next_state[8] = 1; // S8
        end else begin
            next_state[6] = 1; // S6
        end
    end

    if (state[6]) begin // S6
        if (!in) begin
            next_state[9] = 1; // S9
        end else begin
            next_state[7] = 1; // S7
        end
    end

    if (state[7]) begin // S7
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[7] = 1; // S7
        end
        out1 = 0;
        out2 = 1;
    end

    if (state[8]) begin // S8
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[1] = 1; // S1
        end
        out1 = 1;
        out2 = 0;
    end

    if (state[9]) begin // S9
        if (!in) begin
            next_state[0] = 1; // S0
        end else begin
            next_state[1] = 1; // S1
        end
        out1 = 1;
        out2 = 1;
    end
end

endmodule