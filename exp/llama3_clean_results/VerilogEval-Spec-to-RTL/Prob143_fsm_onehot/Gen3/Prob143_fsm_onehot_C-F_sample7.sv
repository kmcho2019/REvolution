module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        // State transitions and output logic
        if (state[0] == 1'b1) begin // S0
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
        end else if (state[1] == 1'b1) begin // S1
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0000_0010;
        end else if (state[2] == 1'b1) begin // S2
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0000_0100;
        end else if (state[3] == 1'b1) begin // S3
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0000_1000;
        end else if (state[4] == 1'b1) begin // S4
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0001_0000;
        end else if (state[5] == 1'b1) begin // S5
            next_state = (in == 1'b0) ? 10'b0_0000_0000_0010 : 10'b0_0000_0110;
        end else if (state[6] == 1'b1) begin // S6
            next_state = (in == 1'b0) ? 10'b0_0000_0000_0100 : 10'b0_0000_1000;
        end else if (state[7] == 1'b1) begin // S7
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0000_0110;
            out1 = 1'b0;
            out2 = 1'b1;
        end else if (state[8] == 1'b1) begin // S8
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
            out1 = 1'b1;
            out2 = 1'b0;
        end else if (state[9] == 1'b1) begin // S9
            next_state = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule