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
        next_state_reg = 10'b0000000000;
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        // Determine the highest priority state that is set
        if (state[9]) begin // S9
            next_state_reg = in ? 10'b0000000010 : 10'b0000000001;
            out1_reg = 1'b1;
            out2_reg = 1'b1;
        end else if (state[8]) begin // S8
            next_state_reg = in ? 10'b0000000010 : 10'b0000000001;
            out1_reg = 1'b1;
            out2_reg = 1'b0;
        end else if (state[7]) begin // S7
            next_state_reg = in ? 10'b1000000000 : 10'b0000000001;
            out1_reg = 1'b0;
            out2_reg = in ? 1'b1 : 1'b0;
        end else if (state[6]) begin // S6
            next_state_reg = in ? 10'b1000000000 : 10'b0000000100;
        end else if (state[5]) begin // S5
            next_state_reg = in ? 10'b0100000000 : 10'b1000000000;
        end else if (state[4]) begin // S4
            next_state_reg = in ? 10'b0000010000 : 10'b0000000001;
        end else if (state[3]) begin // S3
            next_state_reg = in ? 10'b0000100000 : 10'b0000000001;
        end else if (state[2]) begin // S2
            next_state_reg = in ? 10'b0001000000 : 10'b0000000001;
        end else if (state[1]) begin // S1
            next_state_reg = in ? 10'b0010000000 : 10'b0000000001;
        end else if (state[0]) begin // S0
            next_state_reg = in ? 10'b0010000000 : 10'b0000000001;
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule