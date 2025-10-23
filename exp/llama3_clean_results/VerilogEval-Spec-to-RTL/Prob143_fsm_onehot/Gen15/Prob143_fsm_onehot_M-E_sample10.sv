module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [3:0] bin_state; // Binary representation of the state
    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    // Priority encoder to convert one-hot encoded state to binary representation
    always @(*) begin
        bin_state = 4'b0000;
        if (state[9]) bin_state = 4'b1001;
        else if (state[8]) bin_state = 4'b1000;
        else if (state[7]) bin_state = 4'b0111;
        else if (state[6]) bin_state = 4'b0110;
        else if (state[5]) bin_state = 4'b0101;
        else if (state[4]) bin_state = 4'b0100;
        else if (state[3]) bin_state = 4'b0011;
        else if (state[2]) bin_state = 4'b0010;
        else if (state[1]) bin_state = 4'b0001;
        else if (state[0]) bin_state = 4'b0000;
    end

    // Determine next state and outputs based on binary representation of state
    always @(*) begin
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        case (bin_state)
            4'b0000: next_state_reg[in ? 1 : 0] = 1'b1; // S0
            4'b0001: next_state_reg[in ? 2 : 0] = 1'b1; // S1
            4'b0010: next_state_reg[in ? 3 : 0] = 1'b1; // S2
            4'b0011: next_state_reg[in ? 4 : 0] = 1'b1; // S3
            4'b0100: next_state_reg[in ? 5 : 0] = 1'b1; // S4
            4'b0101: next_state_reg[in ? 6 : 8] = 1'b1; // S5
            4'b0110: next_state_reg[in ? 7 : 9] = 1'b1; // S6
            4'b0111: begin
                next_state_reg[in ? 7 : 0] = 1'b1; // S7
                out2_reg = 1'b1;
            end
            4'b1000: begin
                next_state_reg[in ? 1 : 0] = 1'b1; // S8
                out1_reg = 1'b1;
            end
            4'b1001: begin
                next_state_reg[in ? 1 : 0] = 1'b1; // S9
                out1_reg = 1'b1;
                out2_reg = 1'b1;
            end
            default: next_state_reg[0] = 1'b1; // Default state
        endcase
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule