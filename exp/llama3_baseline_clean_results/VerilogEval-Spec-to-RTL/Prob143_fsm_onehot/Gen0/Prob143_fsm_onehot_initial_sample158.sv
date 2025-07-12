module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    // Initialize next state and outputs
    next_state = 10'b0000000000;
    out1 = 1'b0;
    out2 = 1'b0;

    // Handle each state
    if (state[0] == 1'b1) begin
        // S0
        if (in == 1'b0) begin
            // S0 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S0 --1--> S1
            next_state[1] = 1'b1;
        end
    end

    if (state[1] == 1'b1) begin
        // S1
        if (in == 1'b0) begin
            // S1 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S1 --1--> S2
            next_state[2] = 1'b1;
        end
    end

    if (state[2] == 1'b1) begin
        // S2
        if (in == 1'b0) begin
            // S2 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S2 --1--> S3
            next_state[3] = 1'b1;
        end
    end

    if (state[3] == 1'b1) begin
        // S3
        if (in == 1'b0) begin
            // S3 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S3 --1--> S4
            next_state[4] = 1'b1;
        end
    end

    if (state[4] == 1'b1) begin
        // S4
        if (in == 1'b0) begin
            // S4 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S4 --1--> S5
            next_state[5] = 1'b1;
        end
    end

    if (state[5] == 1'b1) begin
        // S5
        if (in == 1'b0) begin
            // S5 --0--> S8
            next_state[8] = 1'b1;
        end else begin
            // S5 --1--> S6
            next_state[6] = 1'b1;
        end
    end

    if (state[6] == 1'b1) begin
        // S6
        if (in == 1'b0) begin
            // S6 --0--> S9
            next_state[9] = 1'b1;
        end else begin
            // S6 --1--> S7
            next_state[7] = 1'b1;
        end
    end

    if (state[7] == 1'b1) begin
        // S7
        if (in == 1'b0) begin
            // S7 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S7 --1--> S7
            next_state[7] = 1'b1;
            out2 = 1'b1;
        end
    end

    if (state[8] == 1'b1) begin
        // S8
        if (in == 1'b0) begin
            // S8 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S8 --1--> S1
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
    end

    if (state[9] == 1'b1) begin
        // S9
        if (in == 1'b0) begin
            // S9 --0--> S0
            next_state[0] = 1'b1;
        end else begin
            // S9 --1--> S1
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule