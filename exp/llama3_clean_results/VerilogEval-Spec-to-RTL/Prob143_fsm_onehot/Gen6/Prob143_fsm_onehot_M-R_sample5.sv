module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        // Initialize next_state to zero and outputs to zero
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        case (1'b1)
            state[0]: begin // S0
                next_state = (in == 1'b0) ? 10'b1 : 10'b10;
            end
            state[1]: begin // S1
                next_state = (in == 1'b0) ? 10'b1 : 10'b100;
            end
            state[2]: begin // S2
                next_state = (in == 1'b0) ? 10'b1 : 10'b1000;
            end
            state[3]: begin // S3
                next_state = (in == 1'b0) ? 10'b1 : 10'b10000;
            end
            state[4]: begin // S4
                next_state = (in == 1'b0) ? 10'b1 : 10'b100000;
            end
            state[5]: begin // S5
                next_state = (in == 1'b0) ? 10'b100000000 : 10'b1000000;
            end
            state[6]: begin // S6
                next_state = (in == 1'b0) ? 10'b1000000000 : 10'b10000000;
            end
            state[7]: begin // S7
                next_state = (in == 1'b0) ? 10'b1 : 10'b10000000;
                out2 = 1'b1;
            end
            state[8]: begin // S8
                next_state = (in == 1'b0) ? 10'b1 : 10'b10;
                out1 = 1'b1;
            end
            state[9]: begin // S9
                next_state = (in == 1'b0) ? 10'b1 : 10'b10;
                out1 = 1'b1;
                out2 = 1'b1;
            end
        endcase
    end

endmodule