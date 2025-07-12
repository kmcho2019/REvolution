module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;

    for (int i = 0; i < 10; i++) begin
        if (state[i] == 1'b1) begin
            case (i)
                0: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                end
                1: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[2] = 1'b1;
                    end
                end
                2: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[3] = 1'b1;
                    end
                end
                3: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[4] = 1'b1;
                    end
                end
                4: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[5] = 1'b1;
                    end
                end
                5: begin
                    if (in == 1'b0) begin
                        next_state[8] = 1'b1;
                    end else begin
                        next_state[6] = 1'b1;
                    end
                end
                6: begin
                    if (in == 1'b0) begin
                        next_state[9] = 1'b1;
                    end else begin
                        next_state[7] = 1'b1;
                    end
                end
                7: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[7] = 1'b1;
                    end
                    out1 = 1'b0;
                    out2 = 1'b1;
                end
                8: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                    out1 = 1'b1;
                    out2 = 1'b0;
                end
                9: begin
                    if (in == 1'b0) begin
                        next_state[0] = 1'b1;
                    end else begin
                        next_state[1] = 1'b1;
                    end
                    out1 = 1'b1;
                    out2 = 1'b1;
                end
                default: begin
                end
            endcase
        end
    end
end

endmodule