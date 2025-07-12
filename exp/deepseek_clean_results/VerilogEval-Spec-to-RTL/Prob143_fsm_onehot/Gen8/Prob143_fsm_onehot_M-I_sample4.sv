module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// Optional one-hot check (commented for synthesis)
// always @(*) begin
//     if ($countones(state) > 1) $display("Warning: Non one-hot state encoding");
// end

always @(*) begin
    // Default outputs and next state
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;
    
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
            out2 = 1'b1;
        end
        10'b0100000000: begin // S8
            next_state[0] = ~in;
            next_state[1] = in;
            out1 = 1'b1;
        end
        10'b1000000000: begin // S9
            next_state[0] = ~in;
            next_state[1] = in;
            out1 = 1'b1;
            out2 = 1'b1;
        end
        default: begin
            next_state = 10'b0;
        end
    endcase
end

endmodule