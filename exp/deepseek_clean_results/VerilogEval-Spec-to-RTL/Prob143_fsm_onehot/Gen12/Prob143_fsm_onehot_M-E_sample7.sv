module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    next_state = 10'b0;
    
    casez (state)
        10'b?????????1: begin // S9 highest priority
            next_state[0] = ~in;
            next_state[1] = in;
        end
        10'b????????1?: begin // S8
            next_state[0] = ~in;
            next_state[1] = in;
        end
        10'b???????1??: begin // S7
            next_state[0] = ~in;
            next_state[7] = in;
        end
        10'b??????1???: begin // S6
            next_state[9] = ~in;
            next_state[7] = in;
        end
        10'b?????1????: begin // S5
            next_state[8] = ~in;
            next_state[6] = in;
        end
        10'b????1?????: begin // S4
            next_state[0] = ~in;
            next_state[5] = in;
        end
        10'b???1??????: begin // S3
            next_state[0] = ~in;
            next_state[4] = in;
        end
        10'b??1???????: begin // S2
            next_state[0] = ~in;
            next_state[3] = in;
        end
        10'b?1????????: begin // S1
            next_state[0] = ~in;
            next_state[2] = in;
        end
        10'b1?????????: begin // S0
            next_state[0] = ~in;
            next_state[1] = in;
        end
        default: next_state = 10'b0;
    endcase
end

// Output logic remains simple but now benefits from priority encoding
assign out1 = |state[9:8];  // S9 or S8
assign out2 = |state[9:7] & state[7]; // S9 or S7, but S9 is already handled in priority

endmodule