module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        // Directly check and handle each state
        if (state[0]) next_state_reg = in ? 10'b0000000001 : 10'b0000000001; // S0
        else if (state[1]) next_state_reg = in ? 10'b0000000100 : 10'b0000000001; // S1
        else if (state[2]) next_state_reg = in ? 10'b0000001000 : 10'b0000000001; // S2
        else if (state[3]) next_state_reg = in ? 10'b0000010000 : 10'b0000000001; // S3
        else if (state[4]) next_state_reg = in ? 10'b0000100000 : 10'b0000000001; // S4
        else if (state[5]) next_state_reg = in ? 10'b0001000000 : 10'b1000000000; // S5
        else if (state[6]) next_state_reg = in ? 10'b0100000000 : 10'b0100000000; // S6
        else if (state[7]) begin
            next_state_reg = in ? 10'b0100000000 : 10'b0000000001; // S7
            out2_reg = 1'b1;
        end
        else if (state[8]) begin
            next_state_reg = in ? 10'b0000000001 : 10'b0000000001; // S8
            out1_reg = 1'b1;
        end
        else if (state[9]) begin
            next_state_reg = in ? 10'b0000000001 : 10'b0000000001; // S9
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end
        else next_state_reg = 10'b0000000001; // Default state

    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule