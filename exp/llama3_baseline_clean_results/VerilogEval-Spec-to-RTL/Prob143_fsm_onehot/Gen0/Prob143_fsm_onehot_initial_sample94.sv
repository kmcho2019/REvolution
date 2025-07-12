module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = 10'b0;

    // Next state logic
    always @(state, in) begin
        if (state[0]) begin // S0
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end else if (state[1]) begin // S1
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[2] = 1'b1;
            end
        end else if (state[2]) begin // S2
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[3] = 1'b1;
            end
        end else if (state[3]) begin // S3
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[4] = 1'b1;
            end
        end else if (state[4]) begin // S4
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[5] = 1'b1;
            end
        end else if (state[5]) begin // S5
            if (!in) begin
                next_state[8] = 1'b1;
            end else begin
                next_state[6] = 1'b1;
            end
        end else if (state[6]) begin // S6
            if (!in) begin
                next_state[9] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end else if (state[7]) begin // S7
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end else if (state[8]) begin // S8
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end else if (state[9]) begin // S9
            if (!in) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end
    end

    // Output logic
    assign out1 = (state[7] & in) | state[8] | state[9];
    assign out2 = (state[7] & in) | state[9];

endmodule