module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(state, in) begin
    next_state = 10'b0000000000; // Initialize next_state to all zeros
    out1 = 1'b0; // Initialize out1 to zero
    out2 = 1'b0; // Initialize out2 to zero

    if (state[0] == 1'b1) begin // If current state is S0
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[1] = 1'b1; // Next state is S1
        end
    end else if (state[1] == 1'b1) begin // If current state is S1
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[2] = 1'b1; // Next state is S2
        end
    end else if (state[2] == 1'b1) begin // If current state is S2
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[3] = 1'b1; // Next state is S3
        end
    end else if (state[3] == 1'b1) begin // If current state is S3
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[4] = 1'b1; // Next state is S4
        end
    end else if (state[4] == 1'b1) begin // If current state is S4
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[5] = 1'b1; // Next state is S5
        end
    end else if (state[5] == 1'b1) begin // If current state is S5
        if (in == 1'b0) begin
            next_state[8] = 1'b1; // Next state is S8
        end else begin
            next_state[6] = 1'b1; // Next state is S6
        end
    end else if (state[6] == 1'b1) begin // If current state is S6
        if (in == 1'b0) begin
            next_state[9] = 1'b1; // Next state is S9
        end else begin
            next_state[7] = 1'b1; // Next state is S7
        end
    end else if (state[7] == 1'b1) begin // If current state is S7
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[7] = 1'b1; // Next state is S7
        end
        out1 = 1'b0; // out1 is 0
        out2 = 1'b1; // out2 is 1
    end else if (state[8] == 1'b1) begin // If current state is S8
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[1] = 1'b1; // Next state is S1
        end
        out1 = 1'b1; // out1 is 1
        out2 = 1'b0; // out2 is 0
    end else if (state[9] == 1'b1) begin // If current state is S9
        if (in == 1'b0) begin
            next_state[0] = 1'b1; // Next state is S0
        end else begin
            next_state[1] = 1'b1; // Next state is S1
        end
        out1 = 1'b1; // out1 is 1
        out2 = 1'b1; // out2 is 1
    end
end

endmodule