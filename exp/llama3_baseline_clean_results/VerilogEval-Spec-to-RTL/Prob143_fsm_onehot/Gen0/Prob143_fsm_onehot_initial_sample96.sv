module TopModule (
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = 10'b0;
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Check each state and assign next state and output values accordingly
    if (state[0]) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[1] = 1'b1;
        end
    end

    if (state[1]) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[2] = 1'b1;
        end
    end

    if (state[2]) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[3] = 1'b1;
        end
    end

    if (state[3]) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[4] = 1'b1;
        end
    end

    if (state[4]) begin
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[5] = 1'b1;
        end
    end

    if (state[5]) begin
        if (!in) begin
            assign next_state[8] = 1'b1;
        end else begin
            assign next_state[6] = 1'b1;
        end
    end

    if (state[6]) begin
        if (!in) begin
            assign next_state[9] = 1'b1;
        end else begin
            assign next_state[7] = 1'b1;
        end
    end

    if (state[7]) begin
        assign out1 = 1'b0;
        assign out2 = 1'b1;
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[7] = 1'b1;
        end
    end

    if (state[8]) begin
        assign out1 = 1'b1;
        assign out2 = 1'b0;
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[1] = 1'b1;
        end
    end

    if (state[9]) begin
        assign out1 = 1'b1;
        assign out2 = 1'b1;
        if (!in) begin
            assign next_state[0] = 1'b1;
        end else begin
            assign next_state[1] = 1'b1;
        end
    end

endmodule