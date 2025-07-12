module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to all zeros
assign next_state = 10'b0000000000;

// Initialize out1 and out2 to zeros
assign out1 = 1'b0;
assign out2 = 1'b0;

// State transition logic
always @(*) begin
    if (state[0] == 1'b1 && in == 1'b0) begin
        // S0 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[0] == 1'b1 && in == 1'b1) begin
        // S0 --1--> S1
        next_state[1] = 1'b1;
    end else if (state[1] == 1'b1 && in == 1'b0) begin
        // S1 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[1] == 1'b1 && in == 1'b1) begin
        // S1 --1--> S2
        next_state[2] = 1'b1;
    end else if (state[2] == 1'b1 && in == 1'b0) begin
        // S2 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[2] == 1'b1 && in == 1'b1) begin
        // S2 --1--> S3
        next_state[3] = 1'b1;
    end else if (state[3] == 1'b1 && in == 1'b0) begin
        // S3 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[3] == 1'b1 && in == 1'b1) begin
        // S3 --1--> S4
        next_state[4] = 1'b1;
    end else if (state[4] == 1'b1 && in == 1'b0) begin
        // S4 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[4] == 1'b1 && in == 1'b1) begin
        // S4 --1--> S5
        next_state[5] = 1'b1;
    end else if (state[5] == 1'b1 && in == 1'b0) begin
        // S5 --0--> S8
        next_state[8] = 1'b1;
    end else if (state[5] == 1'b1 && in == 1'b1) begin
        // S5 --1--> S6
        next_state[6] = 1'b1;
    end else if (state[6] == 1'b1 && in == 1'b0) begin
        // S6 --0--> S9
        next_state[9] = 1'b1;
    end else if (state[6] == 1'b1 && in == 1'b1) begin
        // S6 --1--> S7
        next_state[7] = 1'b1;
    end else if (state[7] == 1'b1 && in == 1'b0) begin
        // S7 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[7] == 1'b1 && in == 1'b1) begin
        // S7 --1--> S7
        next_state[7] = 1'b1;
    end else if (state[8] == 1'b1 && in == 1'b0) begin
        // S8 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[8] == 1'b1 && in == 1'b1) begin
        // S8 --1--> S1
        next_state[1] = 1'b1;
    end else if (state[9] == 1'b1 && in == 1'b0) begin
        // S9 --0--> S0
        next_state[0] = 1'b1;
    end else if (state[9] == 1'b1 && in == 1'b1) begin
        // S9 --1--> S1
        next_state[1] = 1'b1;
    end

    // Handle combinations of states
    if (state[7] == 1'b1 && in == 1'b0) begin
        out2 = 1'b1;
    end else if (state[8] == 1'b1) begin
        out1 = 1'b1;
    end else if (state[9] == 1'b1) begin
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule