module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] next_state_temp;

    // Decoding logic for each state
    always @(*) begin
        next_state_temp = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        // S0-S4
        if (state[0] || state[1] || state[2] || state[3] || state[4]) begin
            next_state_temp[in? (state[4] ? 5 : (state[3] ? 4 : (state[2] ? 3 : (state[1] ? 2 : (state[0] ? 1 : 0)))) : 0] = 1'b1;
        end

        // S5
        if (state[5]) begin
            next_state_temp[in? 6 : 8] = 1'b1;
        end

        // S6
        if (state[6]) begin
            next_state_temp[in? 7 : 9] = 1'b1;
        end

        // S7
        if (state[7]) begin
            next_state_temp[in? 7 : 0] = 1'b1;
            out2 = 1'b1;
        end

        // S8
        if (state[8]) begin
            next_state_temp[in? 1 : 0] = 1'b1;
            out1 = 1'b1;
        end

        // S9
        if (state[9]) begin
            next_state_temp[in? 1 : 0] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
        end

        next_state = next_state_temp;
    end

endmodule