module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

wire not_in = ~in;

always @(*) begin
    // Default outputs
    out1 = 1'b0;
    out2 = 1'b0;
    next_state = 10'b0;
    
    // State transitions
    casez (state)
        10'b?????????1: begin // S0
            next_state[0] = not_in;
            next_state[1] = in;
        end
        10'b????????1?: begin // S1
            next_state[0] = not_in;
            next_state[2] = in;
        end
        10'b???????1??: begin // S2
            next_state[0] = not_in;
            next_state[3] = in;
        end
        10'b??????1???: begin // S3
            next_state[0] = not_in;
            next_state[4] = in;
        end
        10'b?????1????: begin // S4
            next_state[0] = not_in;
            next_state[5] = in;
        end
        10'b????1?????: begin // S5
            next_state[8] = not_in;
            next_state[6] = in;
        end
        10'b???1??????: begin // S6
            next_state[9] = not_in;
            next_state[7] = in;
        end
        10'b??1???????: begin // S7
            next_state[0] = not_in;
            next_state[7] = in;
            out2 = 1'b1;
        end
        10'b?1????????: begin // S8
            next_state[0] = not_in;
            next_state[1] = in;
            out1 = 1'b1;
        end
        10'b1?????????: begin // S9
            next_state[0] = not_in;
            next_state[1] = in;
            out1 = 1'b1;
            out2 = 1'b1;
        end
    endcase
end

endmodule