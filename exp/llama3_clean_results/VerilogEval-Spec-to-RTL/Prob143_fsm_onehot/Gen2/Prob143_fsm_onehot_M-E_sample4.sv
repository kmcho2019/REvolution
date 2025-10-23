module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] tmp_next_state;
    reg tmp_out1;
    reg tmp_out2;

    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;
        tmp_next_state = 10'b0;
        tmp_out1 = 1'b0;
        tmp_out2 = 1'b0;

        for (int i = 0; i < 10; i = i + 1) begin
            if (state[i] == 1'b1) begin
                case (i)
                    0: begin // S0
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[1] = 1'b1;
                        end
                    end
                    1: begin // S1
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[2] = 1'b1;
                        end
                    end
                    2: begin // S2
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[3] = 1'b1;
                        end
                    end
                    3: begin // S3
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[4] = 1'b1;
                        end
                    end
                    4: begin // S4
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[5] = 1'b1;
                        end
                    end
                    5: begin // S5
                        if (in == 1'b0) begin
                            tmp_next_state[8] = 1'b1;
                        end else begin
                            tmp_next_state[6] = 1'b1;
                        end
                    end
                    6: begin // S6
                        if (in == 1'b0) begin
                            tmp_next_state[9] = 1'b1;
                        end else begin
                            tmp_next_state[7] = 1'b1;
                        end
                    end
                    7: begin // S7
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[7] = 1'b1;
                        end
                        tmp_out2 = 1'b1;
                    end
                    8: begin // S8
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[1] = 1'b1;
                        end
                        tmp_out1 = 1'b1;
                    end
                    9: begin // S9
                        if (in == 1'b0) begin
                            tmp_next_state[0] = 1'b1;
                        end else begin
                            tmp_next_state[1] = 1'b1;
                        end
                        tmp_out1 = 1'b1;
                        tmp_out2 = 1'b1;
                    end
                endcase
            end
        end

        next_state = tmp_next_state;
        out1 = tmp_out1;
        out2 = tmp_out2;
    end

endmodule