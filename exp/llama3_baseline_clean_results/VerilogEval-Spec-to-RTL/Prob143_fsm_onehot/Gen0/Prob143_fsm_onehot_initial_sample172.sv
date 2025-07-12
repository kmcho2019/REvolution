module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to 0
assign next_state = 10'b0000000000;

// Evaluate the current state and input 'in' to determine the next state
always @(*) begin
    out1 = 1'b0;
    out2 = 1'b0;

    // Check each state bit and apply the corresponding transition logic
    if (state[0]) begin // S0
        if (~in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
    end

    if (state[1]) begin // S1
        if (~in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[2] = 1'b1;
        end
    end

    if (state[2]) begin // S2
        if (~in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[3] = 1'b1;
        end
    end

    if (state[3]) begin // S3
        if (~in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[4] = 1'b1;
        end
    end

    if (state[4]) begin // S4
        if (~in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[5] = 1'b1;
        end
    end

    if (state[5]) begin // S5
        if (~in) begin
            next_state[8] = 1'b1;
        end else begin
            next_state[6] = 1'b1;
        end
    end

    if (state[6]) begin // S6
        if (~in) begin
            next_state[9] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
        end
    end

    if (state[7]) begin // S7
        if (~in) begin
            next_state[0] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end else begin
            next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end

    if (state[8]) begin // S8
        if (~in) begin
            next_state[0] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b0;
        end else begin
            next_state[1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b0;
        end
    end

    if (state[9]) begin // S9
        if (~in) begin
            next_state[0] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
        end else begin
            next_state[1] = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end
end

endmodule