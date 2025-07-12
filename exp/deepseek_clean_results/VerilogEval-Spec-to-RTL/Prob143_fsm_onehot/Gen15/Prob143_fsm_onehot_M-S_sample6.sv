module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic remains simple
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

always @(*) begin
    next_state = 10'b0;
    casez (state)
        10'b0000000001: begin // S0
            next_state[0] = ~in;
            next_state[1] = in;
        end
        10'b0000000010: begin // S1
            next_state[0] = ~in;
            next_state[2] = in;
        end
        10'b0000000100: begin // S2
            next_state[0] = ~in;
            next_state[3] = in;
        end
        10'b0000001000: begin // S3
            next_state[0] = ~in;
            next_state[4] = in;
        end
        10'b0000010000: begin // S4
            next_state[0] = ~in;
            next_state[5] = in;
        end
        10'b0000100000: begin // S5
            next_state[8] = ~in;
            next_state[6] = in;
        end
        10'b0001000000: begin // S6
            next_state[9] = ~in;
            next_state[7] = in;
        end
        10'b0010000000: begin // S7
            next_state[0] = ~in;
            next_state[7] = in;
        end
        10'b0100000000: begin // S8
            next_state[0] = ~in;
            next_state[1] = in;
        end
        10'b1000000000: begin // S9
            next_state[0] = ~in;
            next_state[1] = in;
        end
    endcase
end

endmodule