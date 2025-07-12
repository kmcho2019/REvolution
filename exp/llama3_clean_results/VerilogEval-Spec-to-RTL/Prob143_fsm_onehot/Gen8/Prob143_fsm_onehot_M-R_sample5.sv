module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    wire [9:0] next_state_wire;
    wire out1_wire;
    wire out2_wire;

    assign next_state_wire[0] = state[0] && !in | state[1] && !in | state[2] && !in | state[3] && !in | state[4] && !in | state[5] && !in && !in | state[6] && !in && !in | state[7] && !in | state[8] && !in | state[9] && !in;
    assign next_state_wire[1] = state[0] && in | state[8] && in | state[9] && in;
    assign next_state_wire[2] = state[1] && in;
    assign next_state_wire[3] = state[2] && in;
    assign next_state_wire[4] = state[3] && in;
    assign next_state_wire[5] = state[4] && in;
    assign next_state_wire[6] = state[5] && in && in;
    assign next_state_wire[7] = state[6] && in && in | state[7] && in;
    assign next_state_wire[8] = state[5] && in && !in;
    assign next_state_wire[9] = state[6] && in && !in;

    assign out1 = state[8] | state[9];
    assign out2 = state[7];

    assign next_state = next_state_wire;
    assign out1 = out1_wire ? out1 : 1'b0;
    assign out2 = out2_wire ? out2 : 1'b0;

    // Always block for out1_wire and out2_wire for optimization purposes
    always @(*) begin
        out1_wire = state[8] | state[9];
        out2_wire = state[7];
    end

endmodule