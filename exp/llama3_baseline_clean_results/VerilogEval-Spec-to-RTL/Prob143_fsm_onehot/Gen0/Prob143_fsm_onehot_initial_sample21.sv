module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

reg [9:0] next_state;
reg out1, out2;

always @(*) begin
    next_state = 10'b0; // initialize next_state to 0
    out1 = 1'b0; // initialize out1 to 0
    out2 = 1'b0; // initialize out2 to 0

    // check for S0
    if (state[0] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[1] = 1'b1;
        end
    end

    // check for S1
    if (state[1] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[2] = 1'b1;
        end
    end

    // check for S2
    if (state[2] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[3] = 1'b1;
        end
    end

    // check for S3
    if (state[3] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[4] = 1'b1;
        end
    end

    // check for S4
    if (state[4] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[5] = 1'b1;
        end
    end

    // check for S5
    if (state[5] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[8] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[6] = 1'b1;
        end
    end

    // check for S6
    if (state[6] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[9] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[7] = 1'b1;
        end
    end

    // check for S7
    if (state[7] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end

    // check for S8
    if (state[8] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end

    // check for S9
    if (state[9] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else if (in == 1'b1) begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule