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

        // Handle state transitions and output logic
        if (state[0]) begin // S0
            next_state_reg[in ? 1 : 0] = 1'b1;
        end else if (state[1]) begin // S1
            next_state_reg[in ? 2 : 0] = 1'b1;
        end else if (state[2]) begin // S2
            next_state_reg[in ? 3 : 0] = 1'b1;
        end else if (state[3]) begin // S3
            next_state_reg[in ? 4 : 0] = 1'b1;
        end else if (state[4]) begin // S4
            next_state_reg[in ? 5 : 0] = 1'b1;
        end else if (state[5]) begin // S5
            next_state_reg[in ? 6 : 8] = 1'b1;
        end else if (state[6]) begin // S6
            next_state_reg[in ? 7 : 9] = 1'b1;
        end else if (state[7]) begin // S7
            next_state_reg[in ? 7 : 0] = 1'b1;
            out2_reg = 1'b1;
        end else if (state[8]) begin // S8
            next_state_reg[in ? 1 : 0] = 1'b1;
            out1_reg = 1'b1;
        end else if (state[9]) begin // S9
            next_state_reg[in ? 1 : 0] = 1'b1;
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule