module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state with all zeros
    assign next_state = 10'b0;

    // Initialize outputs with zeros
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Generate next state and outputs based on current state and input
    always @(*) begin
        case (1'b1)
            state[0]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                end
            end
            state[1]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[2] = 1'b1;
                end
            end
            state[2]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[3] = 1'b1;
                end
            end
            state[3]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[4] = 1'b1;
                end
            end
            state[4]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[5] = 1'b1;
                end
            end
            state[5]: begin
                if (!in) begin
                    next_state[8] = 1'b1;
                end else begin
                    next_state[6] = 1'b1;
                end
            end
            state[6]: begin
                if (!in) begin
                    next_state[9] = 1'b1;
                end else begin
                    next_state[7] = 1'b1;
                end
            end
            state[7]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                    out1 = 1'b0;
                    out2 = 1'b1;
                end else begin
                    next_state[7] = 1'b1;
                    out1 = 1'b0;
                    out2 = 1'b1;
                end
            end
            state[8]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                    out1 = 1'b1;
                    out2 = 1'b0;
                end else begin
                    next_state[1] = 1'b1;
                    out1 = 1'b1;
                    out2 = 1'b0;
                end
            end
            state[9]: begin
                if (!in) begin
                    next_state[0] = 1'b1;
                    out1 = 1'b1;
                    out2 = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                    out1 = 1'b1;
                    out2 = 1'b1;
                end
            end
        endcase
    end
endmodule