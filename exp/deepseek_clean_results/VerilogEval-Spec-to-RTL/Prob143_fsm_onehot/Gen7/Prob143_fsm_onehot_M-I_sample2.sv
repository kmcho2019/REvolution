module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Default next state (S0) and outputs
    next_state = 10'b0;
    out1 = 0;
    out2 = 0;

    // Handle state transitions
    casez (state)
        10'b???????1??: begin // S7
            next_state[0] = ~in;
            next_state[7] = in;
            out2 = 1;
        end
        10'b??????1???: begin // S8
            next_state[0] = ~in;
            next_state[1] = in;
            out1 = 1;
        end
        10'b?????1????: begin // S9
            next_state[0] = ~in;
            next_state[1] = in;
            out1 = 1;
            out2 = 1;
        end
        10'b????1?????: begin // S6
            next_state[9] = ~in;
            next_state[7] = in;
        end
        10'b???1??????: begin // S5
            next_state[8] = ~in;
            next_state[6] = in;
        end
        10'b??1???????: begin // S4
            next_state[0] = ~in;
            next_state[5] = in;
        end
        10'b?1????????: begin // S3
            next_state[0] = ~in;
            next_state[4] = in;
        end
        10'b1?????????: begin // S2
            next_state[0] = ~in;
            next_state[3] = in;
        end
        10'b000000001?: begin // S1
            next_state[0] = ~in;
            next_state[2] = in;
        end
        10'b0000000001: begin // S0
            next_state[0] = ~in;
            next_state[1] = in;
        end
        default: next_state = 10'b0;
    endcase
end

endmodule