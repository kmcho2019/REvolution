module TopModule (
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always_comb begin
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;

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
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end else if (state[8]) begin // S8
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end else if (state[9]) begin // S9
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end

    // Handle the case when multiple states are set
    for (int i = 0; i < 10; i++) begin
        if (state[i]) begin
            case (i)
                0: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                end
                1: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[2] = 1'b1;
                    end
                end
                2: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[3] = 1'b1;
                    end
                end
                3: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[4] = 1'b1;
                    end
                end
                4: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[5] = 1'b1;
                    end
                end
                5: begin
                    if (!in) begin
                        next_state[8] = 1'b1;
                    end else begin
                        next_state[6] = 1'b1;
                    end
                end
                6: begin
                    if (!in) begin
                        next_state[9] = 1'b1;
                    end else begin
                        next_state[7] = 1'b1;
                    end
                end
                7: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[7] = 1'b1;
                        out1 = 1'b0;
                        out2 = 1'b1;
                    end
                end
                8: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                    out1 = 1'b1;
                    out2 = 1'b0;
                end
                9: begin
                    if (!in) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                    out1 = 1'b1;
                    out2 = 1'b1;
                end
            endcase
        end
    end
end

endmodule