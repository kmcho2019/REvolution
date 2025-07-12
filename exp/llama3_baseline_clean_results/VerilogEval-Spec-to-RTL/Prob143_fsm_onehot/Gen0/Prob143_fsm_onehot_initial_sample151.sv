module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    next_state = 10'b0;  // Initialize next_state to all zeros
    out1 = 1'b0;         // Initialize out1 to zero
    out2 = 1'b0;         // Initialize out2 to zero

    if (state[0] == 1'b1) begin  // S0
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
    end else if (state[1] == 1'b1) begin  // S1
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[2] = 1'b1;
        end
    end else if (state[2] == 1'b1) begin  // S2
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[3] = 1'b1;
        end
    end else if (state[3] == 1'b1) begin  // S3
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[4] = 1'b1;
        end
    end else if (state[4] == 1'b1) begin  // S4
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[5] = 1'b1;
        end
    end else if (state[5] == 1'b1) begin  // S5
        if (in == 1'b0) begin
            next_state[8] = 1'b1;
        end else begin
            next_state[6] = 1'b1;
        end
    end else if (state[6] == 1'b1) begin  // S6
        if (in == 1'b0) begin
            next_state[9] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
        end
    end else if (state[7] == 1'b1) begin  // S7
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end else if (state[8] == 1'b1) begin  // S8
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end else if (state[9] == 1'b1) begin  // S9
        if (in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule