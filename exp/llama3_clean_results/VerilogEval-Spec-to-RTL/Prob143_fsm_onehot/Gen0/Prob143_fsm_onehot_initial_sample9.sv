module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to all zeros
assign next_state = 10'b0000000000;

// Initialize outputs to zeros
assign out1 = 1'b0;
assign out2 = 1'b0;

// Determine the next state based on the current state and input
always @(*) begin
    case (1'b1)
        state[0] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[0] & in: begin
            next_state[1] = 1'b1;
        end
        state[1] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[1] & in: begin
            next_state[2] = 1'b1;
        end
        state[2] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[2] & in: begin
            next_state[3] = 1'b1;
        end
        state[3] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[3] & in: begin
            next_state[4] = 1'b1;
        end
        state[4] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[4] & in: begin
            next_state[5] = 1'b1;
        end
        state[5] & ~in: begin
            next_state[8] = 1'b1;
        end
        state[5] & in: begin
            next_state[6] = 1'b1;
        end
        state[6] & ~in: begin
            next_state[9] = 1'b1;
        end
        state[6] & in: begin
            next_state[7] = 1'b1;
        end
        state[7] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[7] & in: begin
            next_state[7] = 1'b1;
        end
        state[8] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[8] & in: begin
            next_state[1] = 1'b1;
        end
        state[9] & ~in: begin
            next_state[0] = 1'b1;
        end
        state[9] & in: begin
            next_state[1] = 1'b1;
        end
    endcase
end

// Determine the outputs based on the current state
always @(*) begin
    if (state[7]) begin
        out1 = 1'b0;
        out2 = 1'b1;
    end else if (state[8]) begin
        out1 = 1'b1;
        out2 = 1'b0;
    end else if (state[9]) begin
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule