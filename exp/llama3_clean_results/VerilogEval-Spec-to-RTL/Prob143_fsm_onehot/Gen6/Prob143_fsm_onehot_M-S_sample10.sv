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

        // Handle state transitions and output logic
        case (1'b1)
            state[0]: begin // S0
                next_state = in? 10'b0000000001 : 10'b0000000001;
            end
            state[1]: begin // S1
                next_state = in? 10'b0000000010 : 10'b0000000001;
            end
            state[2]: begin // S2
                next_state = in? 10'b0000000100 : 10'b0000000001;
            end
            state[3]: begin // S3
                next_state = in? 10'b0000001000 : 10'b0000000001;
            end
            state[4]: begin // S4
                next_state = in? 10'b0000010000 : 10'b0000000001;
            end
            state[5]: begin // S5
                next_state = in? 10'b0000100000 : 10'b0000010000;
            end
            state[6]: begin // S6
                next_state = in? 10'b0001000000 : 10'b0000100000;
            end
            state[7]: begin // S7
                next_state = in? 10'b0001000000 : 10'b0000000001;
                out2 = in? 1'b1 : 1'b0;
            end
            state[8]: begin // S8
                next_state = in? 10'b0000000001 : 10'b0000000001;
                out1 = 1'b1;
            end
            state[9]: begin // S9
                next_state = in? 10'b0000000001 : 10'b0000000001;
                out1 = 1'b1;
                out2 = 1'b1;
            end
            default: begin
                next_state = 10'b0000000001;
            end
        endcase
    end

endmodule