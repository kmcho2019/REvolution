module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic optimized with bitwise OR
assign out1 = |(state & 10'b0110000000);  // S8 or S9
assign out2 = |(state & 10'b1001000000);  // S7 or S9

wire in_n = ~in;

always @(*) begin
    next_state = 10'b0;
    
    // Use casez for prioritized state handling
    casez (state)
        // Higher priority to later states (S9 has highest priority)
        10'b?????????1: begin // S9
            next_state[0] = in_n;
            next_state[1] = in;
        end
        10'b????????1?: begin // S8
            next_state[0] = in_n;
            next_state[1] = in;
        end
        10'b???????1??: begin // S7
            next_state[0] = in_n;
            next_state[7] = in;
        end
        10'b??????1???: begin // S6
            next_state[9] = in_n;
            next_state[7] = in;
        end
        10'b?????1????: begin // S5
            next_state[8] = in_n;
            next_state[6] = in;
        end
        10'b????1?????: begin // S4
            next_state[0] = in_n;
            next_state[5] = in;
        end
        10'b???1??????: begin // S3
            next_state[0] = in_n;
            next_state[4] = in;
        end
        10'b??1???????: begin // S2
            next_state[0] = in_n;
            next_state[3] = in;
        end
        10'b?1????????: begin // S1
            next_state[0] = in_n;
            next_state[2] = in;
        end
        10'b1?????????: begin // S0
            next_state[0] = in_n;
            next_state[1] = in;
        end
        default: next_state = 10'b0;
    endcase
end

endmodule