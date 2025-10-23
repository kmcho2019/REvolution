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

    if (state[0]) next_state[!in ? 0 : 1] = 1'b1;
    if (state[1]) next_state[!in ? 0 : 2] = 1'b1;
    if (state[2]) next_state[!in ? 0 : 3] = 1'b1;
    if (state[3]) next_state[!in ? 0 : 4] = 1'b1;
    if (state[4]) next_state[!in ? 0 : 5] = 1'b1;
    if (state[5]) next_state[!in ? 8 : 6] = 1'b1;
    if (state[6]) next_state[!in ? 9 : 7] = 1'b1;
    if (state[7]) begin
        next_state[!in ? 0 : 7] = 1'b1;
        out2 = 1'b1;
    end
    if (state[8]) begin
        next_state[!in ? 0 : 1] = 1'b1;
        out1 = 1'b1;
    end
    if (state[9]) begin
        next_state[!in ? 0 : 1] = 1'b1;
        out1 = 1'b1;
        out2 = 1'b1;
    end

endmodule