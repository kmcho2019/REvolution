module TopModule(clk, resetn, x, y, f, g);
    input clk;
    input resetn;
    input x;
    input y;
    output f;
    output g;

    reg [2:0] state; // 0: State A, 1: State B, 2: State C, 3: State D, 4: State E, 5: State F
    reg [1:0] xSeq; // To monitor the sequence of x
    reg [1:0] yCount; // To count the number of cycles after entering State D

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 0;
            xSeq <= 0;
            yCount <= 0;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                0: begin // State A
                    if (resetn) begin
                        state <= 1;
                        f <= 1;
                    end else begin
                        state <= 0;
                    end
                end
                1: begin // State B
                    state <= 2;
                    f <= 0;
                    xSeq <= 0;
                end
                2: begin // State C
                    case (xSeq)
                        0: begin
                            if (x) begin
                                xSeq <= 1;
                            end
                        end
                        1: begin
                            if (!x) begin
                                xSeq <= 2;
                            end else begin
                                xSeq <= 1;
                            end
                        end
                        2: begin
                            if (x) begin
                                state <= 3;
                                g <= 1;
                                yCount <= 0;
                            end else begin
                                xSeq <= 2;
                            end
                        end
                    endcase
                end
                3: begin // State D
                    yCount <= yCount + 1;
                    if (y) begin
                        state <= 4;
                    end else if (yCount == 2) begin
                        state <= 5;
                    end
                end
                4: begin // State E
                    g <= 1;
                end
                5: begin // State F
                    g <= 0;
                end
            endcase
        end
    end

endmodule