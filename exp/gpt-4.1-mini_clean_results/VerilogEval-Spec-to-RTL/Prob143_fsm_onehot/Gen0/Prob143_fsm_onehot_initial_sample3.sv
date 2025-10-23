module TopModule(
    input  in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Initialize next_state and outputs to zero
    next_state = 10'b0;
    out1 = 0;
    out2 = 0;

    // For each active state bit, determine next states and outputs

    // S0: state[0]
    // (0,0), transitions: 0->S0, 1->S1
    if (state[0]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[1] = 1'b1;
        // outputs 0,0
    end

    // S1: state[1]
    // (0,0), transitions: 0->S0, 1->S2
    if (state[1]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[2] = 1'b1;
        // outputs 0,0
    end

    // S2: state[2]
    // (0,0), transitions: 0->S0, 1->S3
    if (state[2]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[3] = 1'b1;
        // outputs 0,0
    end

    // S3: state[3]
    // (0,0), transitions: 0->S0, 1->S4
    if (state[3]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[4] = 1'b1;
        // outputs 0,0
    end

    // S4: state[4]
    // (0,0), transitions: 0->S0, 1->S5
    if (state[4]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[5] = 1'b1;
        // outputs 0,0
    end

    // S5: state[5]
    // (0,0), transitions: 0->S8, 1->S6
    if (state[5]) begin
        if (in == 0) next_state[8] = 1'b1;
        else         next_state[6] = 1'b1;
        // outputs 0,0
    end

    // S6: state[6]
    // (0,0), transitions: 0->S9, 1->S7
    if (state[6]) begin
        if (in == 0) next_state[9] = 1'b1;
        else         next_state[7] = 1'b1;
        // outputs 0,0
    end

    // S7: state[7]
    // (0,1), transitions: 0->S0, 1->S7
    if (state[7]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[7] = 1'b1;
        // outputs (0,1)
        out2 = 1'b1;
    end

    // S8: state[8]
    // (1,0), transitions: 0->S0, 1->S1
    if (state[8]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[1] = 1'b1;
        // outputs (1,0)
        out1 = 1'b1;
    end

    // S9: state[9]
    // (1,1), transitions: 0->S0, 1->S1
    if (state[9]) begin
        if (in == 0) next_state[0] = 1'b1;
        else         next_state[1] = 1'b1;
        // outputs (1,1)
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule