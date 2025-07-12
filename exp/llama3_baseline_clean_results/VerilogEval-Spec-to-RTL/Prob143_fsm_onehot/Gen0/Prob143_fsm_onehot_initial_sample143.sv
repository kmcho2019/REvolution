module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = 10'b0;
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Handle S0
    if (state[0] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
    end

    // Handle S1
    if (state[1] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[2] = 1'b1;
        end
    end

    // Handle S2
    if (state[2] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[3] = 1'b1;
        end
    end

    // Handle S3
    if (state[3] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[4] = 1'b1;
        end
    end

    // Handle S4
    if (state[4] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[5] = 1'b1;
        end
    end

    // Handle S5
    if (state[5] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[8] = 1'b1;
        end else begin
            next_state[6] = 1'b1;
        end
    end

    // Handle S6
    if (state[6] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[9] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
        end
    end

    // Handle S7
    if (state[7] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end

    // Handle S8
    if (state[8] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end

    // Handle S9
    if (state[9] == 1'b1) begin
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end

endmodule