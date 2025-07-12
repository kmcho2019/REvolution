module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        if (state[0]) next_state = in? 10'b0000000001 : 10'b0000000001; // S0
        else if (state[1]) next_state = in? 10'b0000000010 : 10'b0000000001; // S1
        else if (state[2]) next_state = in? 10'b0000000100 : 10'b0000000001; // S2
        else if (state[3]) next_state = in? 10'b0000001000 : 10'b0000000001; // S3
        else if (state[4]) next_state = in? 10'b0000010000 : 10'b0000000001; // S4
        else if (state[5]) next_state = in? 10'b0100000000 : 10'b0000100000; // S5
        else if (state[6]) next_state = in? 10'b0000010000 : 10'b0000001000; // S6
        else if (state[7]) next_state = in? 10'b1000000000 : 10'b0000000001; // S7
        else if (state[8]) next_state = in? 10'b0000000001 : 10'b0000000001; out1 = 1'b1; // S8
        else if (state[9]) next_state = in? 10'b0000000001 : 10'b0000000001; out1 = 1'b1; out2 = 1'b1; // S9
        else if (state[7] &&!in) next_state = 10'b1000000000; out2 = 1'b1; // S7
    end

endmodule