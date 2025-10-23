module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output reg out1,
    output reg out2
);

    assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[8] | state[9])) ? 1'b1 : 1'b0;
    assign next_state[1] = (in & (state[0] | state[4] | state[8] | state[9])) ? 1'b1 : 1'b0;
    assign next_state[2] = (in & state[1]) ? 1'b1 : 1'b0;
    assign next_state[3] = (in & state[2]) ? 1'b1 : 1'b0;
    assign next_state[4] = (in & state[3]) ? 1'b1 : 1'b0;
    assign next_state[5] = (in & state[4]) ? 1'b1 : 1'b0;
    assign next_state[6] = (in & state[5]) ? 1'b1 : 1'b0;
    assign next_state[7] = (in & state[6]) ? 1'b1 : 1'b0;
    assign next_state[8] = (~in & state[5]) ? 1'b1 : 1'b0;
    assign next_state[9] = (~in & state[6]) ? 1'b1 : 1'b0;

    always @(*) begin
        out1 = (state[8] | state[9]);
        out2 = (state[7] | state[9]);
    end

endmodule