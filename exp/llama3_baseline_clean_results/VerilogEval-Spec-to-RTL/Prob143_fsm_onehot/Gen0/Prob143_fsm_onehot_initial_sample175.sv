module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to 0
    assign next_state = {10{1'b0}};

    // Initialize outputs to 0
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Check for S7
    if (state[7]) begin
        assign next_state[0] = ~in;
        assign next_state[7] = in;
        assign out1 = 1'b0;
        assign out2 = in;
    end

    // Check for S9
    else if (state[9]) begin
        assign next_state[0] = ~in;
        assign next_state[1] = in;
        assign out1 = 1'b1;
        assign out2 = 1'b1;
    end

    // Check for S8
    else if (state[8]) begin
        assign next_state[0] = ~in;
        assign next_state[1] = in;
        assign out1 = 1'b1;
        assign out2 = 1'b0;
    end

    // Check for S6
    else if (state[6]) begin
        assign next_state[0] = ~in;
        assign next_state[9] = in;
        assign out1 = 1'b0;
        assign out2 = 1'b0;
    end

    // Check for S5
    else if (state[5]) begin
        assign next_state[0] = ~in;
        assign next_state[8] = ~in;
        assign next_state[6] = in;
        assign out1 = 1'b0;
        assign out2 = 1'b0;
    end

    // Check for S4
    else if (state[4]) begin
        assign next_state[0] = ~in;
        assign next_state[5] = in;
        assign out1 = 1'b0;
        assign out2 = 1'b0;
    end

    // Check for S3
    else if (state[3]) begin
        assign next_state[0] = ~in;
        assign next_state[4] = in;
        assign out1 = 1'b0;
        assign out2 = 1'b0;
    end

    // Check for S2
    else if (state[2]) begin
        assign next_state[0] = ~in;
        assign next_state[3] = in;
        assign out1 = 1'b0;
        assign out2 = 1'b0;
    end

    // Check for S1
    else if (state[1]) begin
        assign next_state[0] = ~in;
        assign next_state[2] = in;
        assign out1 = 1'b0;
        assign out2 = 1'b0;
    end

    // Check for S0
    else if (state[0]) begin
        assign next_state[0] = ~in;
        assign next_state[1] = in;
        assign out1 = 1'b0;
        assign out2 = 1'b0;
    end

endmodule