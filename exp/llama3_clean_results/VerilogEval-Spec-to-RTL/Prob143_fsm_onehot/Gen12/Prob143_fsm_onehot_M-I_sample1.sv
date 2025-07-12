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

        // S0
        if (state[0]) begin
            next_state_reg[!in ? 0 : 1] = 1'b1;
        end

        // S1
        else if (state[1]) begin
            next_state_reg[!in ? 0 : 2] = 1'b1;
        end

        // S2
        else if (state[2]) begin
            next_state_reg[!in ? 0 : 3] = 1'b1;
        end

        // S3
        else if (state[3]) begin
            next_state_reg[!in ? 0 : 4] = 1'b1;
        end

        // S4
        else if (state[4]) begin
            next_state_reg[!in ? 0 : 5] = 1'b1;
        end

        // S5
        else if (state[5]) begin
            next_state_reg[!in ? 8 : 6] = 1'b1;
        end

        // S6
        else if (state[6]) begin
            next_state_reg[!in ? 9 : 7] = 1'b1;
        end

        // S7
        else if (state[7]) begin
            next_state_reg[!in ? 0 : 7] = 1'b1;
            out2_reg = 1'b1;
        end

        // S8
        else if (state[8]) begin
            next_state_reg[!in ? 0 : 1] = 1'b1;
            out1_reg = 1'b1;
        end

        // S9
        else if (state[9]) begin
            next_state_reg[!in ? 0 : 1] = 1'b1;
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end

        // Default state
        else begin
            next_state_reg[0] = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule